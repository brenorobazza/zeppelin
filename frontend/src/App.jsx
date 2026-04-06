import { useEffect, useRef, useState } from "react";
import { PlatformLayout } from "./components/PlatformLayout";
import { CreateAccountPage } from "./pages/CreateAccountPage";
import { AssessmentPage } from "./pages/AssessmentPage";
import { DashboardPage } from "./pages/DashboardPage";
import { HistoryPage } from "./pages/HistoryPage";
import { LoginPage } from "./pages/LoginPage";
import { RecommendationsPage } from "./pages/RecommendationsPage";
import { ResultsPage } from "./pages/ResultsPage";
import { SettingsPage } from "./pages/SettingsPage";
import {
  getAnalyticsFiltersFromUrl,
  getFallbackAnalyticsBundle,
  loadAnalyticsBundle,
  updateAnalyticsFiltersInUrl
} from "./services/analytics";

// Lê o hash da URL e traduz isso para a "tela atual" da aplicação.
function getScreenFromHash() {
  const hash = window.location.hash.replace("#", "");
  if (hash === "create-account") return "create-account";
  if (hash === "dashboard") return "dashboard";
  if (hash === "assessment") return "assessment";
  if (hash === "results") return "results";
  if (hash === "recommendations") return "recommendations";
  if (hash === "history") return "history";
  if (hash === "settings") return "settings";
  return "login";
}

export default function App() {
  // Define qual página está visível neste momento.
  const [screen, setScreen] = useState(getScreenFromHash);

  // Guarda apenas o dado mínimo do usuário para apresentação no layout.
  const [user, setUser] = useState(() => {
    try {
      const stored = localStorage.getItem("zeppelin_user");
      return stored ? JSON.parse(stored) : null;
    } catch {
      return null;
    }
  });

  // Reúne os filtros que controlam a análise: empresa, ciclo e escopo.
  const [analyticsFilters, setAnalyticsFilters] = useState(getAnalyticsFiltersFromUrl);

  // Centraliza todos os dados usados pelas telas principais.
  // Também informa se a tela está carregando, se está usando mock e se ocorreu erro.
  const [analytics, setAnalytics] = useState(() => ({
    ...getFallbackAnalyticsBundle(),
    loading: false,
    usingMockData: true,
    error: ""
  }));

  const [refreshKey, setRefreshKey] = useState(0);
  const [disableGlobalSelectors, setDisableGlobalSelectors] = useState(false);
  const lastScreenRef = useRef(screen);

  function triggerRefresh() {
    setRefreshKey(k => k + 1);
  }

  useEffect(() => {
    if (lastScreenRef.current === "assessment" && screen !== "assessment") {
      triggerRefresh();
    }
    lastScreenRef.current = screen;
  }, [screen]);

  useEffect(() => {
    // Sincroniza a interface com a URL sempre que o usuário navega manualmente.
    function syncNavigationState() {
      setScreen(getScreenFromHash());
      setAnalyticsFilters(getAnalyticsFiltersFromUrl());
      setDisableGlobalSelectors(false); // Reset on navigation
    }

    window.addEventListener("hashchange", syncNavigationState);
    window.addEventListener("popstate", syncNavigationState);
    return () => {
      window.removeEventListener("hashchange", syncNavigationState);
      window.removeEventListener("popstate", syncNavigationState);
    };
  }, []);

  // Apenas estas telas dependem do backend analítico.
  const isPlatformScreen = [
    "dashboard",
    "assessment",
    "results",
    "recommendations",
    "history",
    "settings"
  ].includes(screen);

  useEffect(() => {
    if (!isPlatformScreen || !user) return;

    // Evita atualizar estado quando o usuário troca de tela antes da resposta terminar.
    let ignore = false;

    async function syncAnalytics() {
      setAnalytics((current) => ({
        ...current,
        loading: true,
        error: ""
      }));

      try {
        const bundle = await loadAnalyticsBundle(analyticsFilters);

        if (ignore) return;

        setAnalytics({
          ...bundle,
          loading: false,
          usingMockData: false,
          error: ""
        });
      } catch (error) {
        if (ignore) return;

        if (error.status === 401) {
          setUser(null);
          window.location.hash = "login";
          setScreen("login");
          return;
        }

        setAnalytics({
          ...getFallbackAnalyticsBundle(),
          loading: false,
          usingMockData: true,
          error: error.message || "Failed to load analytics from backend."
        });
      }
    }

    syncAnalytics();

    return () => {
      ignore = true;
    };
  }, [isPlatformScreen, user, analyticsFilters.organizationId, analyticsFilters.questionnaireId, analyticsFilters.stageScope, refreshKey]);

  function goToLogin() {
    window.location.hash = "login";
    setScreen("login");
  }

  function goToCreateAccount() {
    window.location.hash = "create-account";
    setScreen("create-account");
  }

  function goToDashboard() {
    window.location.hash = "dashboard";
    setScreen("dashboard");
  }

  function goToScreen(nextScreen) {
    window.location.hash = nextScreen;
    setScreen(nextScreen);
  }

  function logout() {
    setUser(null);
    localStorage.removeItem("zeppelin_user");
    const resetFilters = { organizationId: "", questionnaireId: "", stageScope: "all" };
    setAnalyticsFilters(resetFilters);
    updateAnalyticsFiltersInUrl(resetFilters);
    localStorage.removeItem("organization_id");
    goToLogin();
  }

  function updateUserProfile(nextProfile) {
    setUser((current) => {
      if (!current) return current;

      const nextUser = {
        ...current,
        username: nextProfile.username || current.username,
        fullName: nextProfile.fullName || current.fullName,
        email: nextProfile.email || current.email,
        accessToken: current.accessToken,
      };
      localStorage.setItem("zeppelin_user", JSON.stringify(nextUser));
      return nextUser;
    });
  }

  function updateAnalyticsFilters(nextFilters) {
    setAnalyticsFilters((current) => {
      const next = { ...current, ...nextFilters };
      // Mantém organização e ciclo no URL para suportar histórico por empresa/ciclo.
      updateAnalyticsFiltersInUrl(next);
      return next;
    });
  }

  // Cadastro fica fora do layout interno da plataforma.
  if (screen === "create-account") {
    return <CreateAccountPage onBackToLogin={goToLogin} />;
  }

  // Mapeia cada tela principal para título, subtítulo e componente.
  const pageMap = {
    dashboard: {
      title: "Diagnostic Summary",
      subtitle: "Initial view of the organization's current maturity position in the selected assessment cycle.",
      component: (
        <DashboardPage
          onNavigate={goToScreen}
          data={analytics.dashboard}
          loading={analytics.loading}
        />
      )
    },
    assessment: {
      title: "Assessment Questionnaire",
      subtitle: "Evaluate CSE practices using a standardized maturity scale.",
      component: (
        <AssessmentPage
          organizationId={analyticsFilters.organizationId}
          questionnaireId={analyticsFilters.questionnaireId}
          organizations={user?.organizations || []}
          cycleOptions={analytics.meta?.cycleOptions || []}
          organizationName={analytics.meta?.organizationName}
          onChangeOrganization={(id) => updateAnalyticsFilters({ organizationId: id, questionnaireId: "" })}
          onCycleCreated={(id) => updateAnalyticsFilters({ questionnaireId: id })}
          onViewResults={(qId) => {
            updateAnalyticsFilters({ questionnaireId: qId });
            goToScreen("results");
          }}
          onFinish={() => {
            triggerRefresh();
            goToScreen("results");
          }}
          onExitForm={() => {
            triggerRefresh();
          }}
          onFormStateChange={setDisableGlobalSelectors}
        />
      )
    },
    results: {
      title: "Diagnostic Detail",
      subtitle: "Detailed analytical interpretation of the current diagnosis by stage and practice group.",
      component: (
        <ResultsPage
          data={analytics.results}
          overview={analytics.dashboard}
          loading={analytics.loading}
        />
      )
    },
    recommendations: {
      title: "Recommendations",
      subtitle: "Actions derived from the current diagnostic reading.",
      component: (
        <RecommendationsPage
          data={analytics.recommendations}
          loading={analytics.loading}
        />
      )
    },
    history: {
      title: "Evolution by Cycle",
      subtitle: "What changed across assessment cycles in CI, CD and recommendation load?",
      component: (
        <HistoryPage
          data={analytics.history}
          loading={analytics.loading}
        />
      )
    },
    settings: {
      title: "Organization Settings",
      subtitle: "Review current members and apply removal permissions within the selected organization.",
      component: (
        <SettingsPage
          organizationId={analyticsFilters.organizationId}
          onProfileUpdated={updateUserProfile}
          onSelfRemoved={logout}
        />
      )
    }
  };


  if (user && pageMap[screen]) {
    const page = pageMap[screen];
    return (
      <PlatformLayout
        activePage={screen}
        title={page.title}
        subtitle={page.subtitle}
        organization={analytics.meta.organizationName}
        userName={user.fullName || user.username}
        onNavigate={goToScreen}
        onLogout={logout}
        organizationOptions={user.organizations || []}
        selectedOrganizationId={analyticsFilters.organizationId}
        onOrganizationChange={(value) => updateAnalyticsFilters({ organizationId: value, questionnaireId: "" })}
        cycleOptions={analytics.meta.cycleOptions}
        selectedCycleId={analyticsFilters.questionnaireId}
        onCycleChange={(value) => updateAnalyticsFilters({ questionnaireId: value })}
        usingMockData={analytics.usingMockData}
        analyticsError={analytics.error}
        disableGlobalSelectors={disableGlobalSelectors}
        hideCycleSelector={screen === "assessment"}
      >
        {page.component}
      </PlatformLayout>
    );
  }

  // Caso nenhuma tela interna esteja ativa, a porta de entrada continua sendo o login.
  return (
    <LoginPage
      onCreateAccountClick={goToCreateAccount}
      onLoginSuccess={(loggedUser) => {
        // Inicializa o usuário com seu nome e lista de empresas vinculadas.
        const newUser = { 
          username: loggedUser?.username || "Alex Silva",
          fullName: loggedUser?.full_name || loggedUser?.username || "Alex Silva",
          email: loggedUser?.email || "",
          isAdmin: Boolean(loggedUser?.is_admin),
          organizations: loggedUser?.organizations || []
        };
        setUser(newUser);
        localStorage.setItem("zeppelin_user", JSON.stringify(newUser));

        // Se o usuário possuir empresas, define a primeira como o contexto inicial.
        if (loggedUser?.organizations && loggedUser.organizations.length > 0) {
          updateAnalyticsFilters({ 
            organizationId: String(loggedUser.organizations[0].id),
            questionnaireId: "" // Reseta o ciclo para garantir que não use lixo de sessões anteriores.
          });
        }

        goToDashboard();
      }}
    />
  );
}
