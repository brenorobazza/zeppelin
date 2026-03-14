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
  const [screen, setScreen] = useState(getScreenFromHash);
  const [user, setUser] = useState({ username: "Alex Silva" });
  const [analyticsFilters, setAnalyticsFilters] = useState(getAnalyticsFiltersFromUrl);
  const [analytics, setAnalytics] = useState(() => ({
    ...getFallbackAnalyticsBundle(),
    loading: false,
    usingMockData: true,
    error: ""
  }));

  useEffect(() => {
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

  const isPlatformScreen = [
    "dashboard",
    "assessment",
    "results",
    "recommendations",
    "history",
    "settings"
  ].includes(screen);

  useEffect(() => {
    if (!isPlatformScreen) return;

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
          setUser({ username: "Alex Silva" });
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
  }, [isPlatformScreen, analyticsFilters.organizationId, analyticsFilters.questionnaireId, analyticsFilters.stageScope]);

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
    setUser({ username: "Alex Silva" });
    goToLogin();
  }

  function updateAnalyticsFilters(nextFilters) {
    setAnalyticsFilters((current) => {
      const next = { ...current, ...nextFilters };
      // Mantem organização e ciclo no URL para suportar histórico por empresa/ciclo.
      updateAnalyticsFiltersInUrl(next);
      return next;
    });
  }

  if (screen === "create-account") {
    return <CreateAccountPage onBackToLogin={goToLogin} />;
  }

  const pageMap = {
    dashboard: {
      title: "Executive Dashboard",
      subtitle: "What is the overall result of the calibrated Zeppelin diagnosis for this cycle?",
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
      component: <AssessmentPage />
    },
    results: {
      title: "Diagnosis Results",
      subtitle: "Where are the main strengths and bottlenecks across CI and CD practices?",
      component: <ResultsPage data={analytics.results} loading={analytics.loading} />
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

  if (pageMap[screen]) {
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

  return (
    <LoginPage
      onCreateAccountClick={goToCreateAccount}
      onLoginSuccess={(loggedUser) => {
        setUser({ username: loggedUser?.username || "Alex Silva" });
        goToDashboard();
      }}
    />
  );
}
