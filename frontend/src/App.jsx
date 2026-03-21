import { useEffect, useState } from "react";
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
// A ideia aqui é manter uma navegação simples, fácil de seguir e suficiente para o TCC.
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

  // Centraliza todos os dados usados pelas telas principais do TCC.
  // Também informa se a tela está carregando, se está usando mock e se ocorreu erro.
  const [analytics, setAnalytics] = useState(() => ({
    ...getFallbackAnalyticsBundle(),
    loading: false,
    usingMockData: true,
    error: ""
  }));

  const [refreshKey, setRefreshKey] = useState(0);

  function triggerRefresh() {
    setRefreshKey(k => k + 1);
  }

  useEffect(() => {
    // Sincroniza a interface com a URL sempre que o usuário navega manualmente.
    function syncNavigationState() {
      setScreen(getScreenFromHash());
      setAnalyticsFilters(getAnalyticsFiltersFromUrl());
    }

    window.addEventListener("hashchange", syncNavigationState);
    window.addEventListener("popstate", syncNavigationState);
    return () => {
      window.removeEventListener("hashchange", syncNavigationState);
      window.removeEventListener("popstate", syncNavigationState);
    };
  }, []);

  // Apenas estas telas dependem do backend analítico do TCC.
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
      // Mantém o que já estava em tela e apenas marca que uma nova busca está em andamento.
      setAnalytics((current) => ({
        ...current,
        loading: true,
        error: ""
      }));

      try {
        // Busca todas as seções em paralelo para manter a consistência entre as telas.
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

        // Sessão inválida: volta para o login.
        if (error.status === 401) {
          setUser(null);
          window.location.hash = "login";
          setScreen("login");
          return;
        }

        // Falha de backend: entra em modo demonstração para a interface continuar utilizável.
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
      title: "Executive Diagnostic View",
      subtitle: "Current maturity position in the CSE evolution path for the selected assessment cycle.",
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
      subtitle: "Evaluate CI/CD practices using a standardized maturity scale.",
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
        />
      )
    },    results: {
      title: "Diagnosis Results",
      subtitle: "Analytical view of CSE practice adoption, progression constraints and improvement opportunities.",
      component: (
        <ResultsPage
          data={analytics.results}
          overview={analytics.dashboard}
          loading={analytics.loading}
        />
      )
    },
    recommendations: {
      title: "Improvement Roadmap",
      subtitle: "What should the organization do next based on the rule-based recommendations?",
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
      subtitle: "Manage organization and user profile information.",
      component: <SettingsPage />
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
        userName={user.username}
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
