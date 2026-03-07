import { useEffect, useState } from "react";
import { CreateAccountPage } from "./pages/CreateAccountPage";
import { LoginPage } from "./pages/LoginPage";

function getScreenFromHash() {
  return window.location.hash === "#create-account" ? "create-account" : "login";
}

export default function App() {
  // Controla navegacao entre login e cadastro via hash, sem router externo.
  const [screen, setScreen] = useState(getScreenFromHash);

  useEffect(() => {
    function handleHashChange() {
      setScreen(getScreenFromHash());
    }

    window.addEventListener("hashchange", handleHashChange);
    return () => window.removeEventListener("hashchange", handleHashChange);
  }, []);

  function goToCreateAccount() {
    window.location.hash = "create-account";
    setScreen("create-account");
  }

  function goToLogin() {
    window.location.hash = "";
    setScreen("login");
  }

  if (screen === "create-account") {
    return <CreateAccountPage onBackToLogin={goToLogin} />;
  }

  return <LoginPage onCreateAccountClick={goToCreateAccount} />;
}
