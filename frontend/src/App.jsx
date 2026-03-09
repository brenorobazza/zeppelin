import { useEffect, useState } from "react";
import { PlatformLayout } from "./components/PlatformLayout";
import { maturitySnapshot } from "./mock/zeppelinData";
import { CreateAccountPage } from "./pages/CreateAccountPage";
import { AssessmentPage } from "./pages/AssessmentPage";
import { DashboardPage } from "./pages/DashboardPage";
import { HistoryPage } from "./pages/HistoryPage";
import { LoginPage } from "./pages/LoginPage";
import { RecommendationsPage } from "./pages/RecommendationsPage";
import { ResultsPage } from "./pages/ResultsPage";
import { SettingsPage } from "./pages/SettingsPage";

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

  useEffect(() => {
    function syncByHash() {
      setScreen(getScreenFromHash());
    }

    window.addEventListener("hashchange", syncByHash);
    return () => window.removeEventListener("hashchange", syncByHash);
  }, []);

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

  if (screen === "create-account") {
    return <CreateAccountPage onBackToLogin={goToLogin} />;
  }

  const pageMap = {
    dashboard: {
      title: "Dashboard Overview",
      subtitle: "Executive maturity view with key scores, strengths and bottlenecks.",
      component: <DashboardPage onNavigate={goToScreen} />
    },
    assessment: {
      title: "Assessment Questionnaire",
      subtitle: "Evaluate CI/CD practices using a standardized maturity scale.",
      component: <AssessmentPage />
    },
    results: {
      title: "Assessment Results",
      subtitle: "Strategic diagnosis of your current CI/CD maturity state.",
      component: <ResultsPage />
    },
    recommendations: {
      title: "Recommendations",
      subtitle: "Prioritized action backlog to accelerate maturity improvement.",
      component: <RecommendationsPage />
    },
    history: {
      title: "History & Evolution",
      subtitle: "Track score progression across past assessment cycles.",
      component: <HistoryPage />
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
        organization={maturitySnapshot.organization}
        userName={user.username}
        onNavigate={goToScreen}
        onLogout={logout}
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
