import "./platform-layout.css";

// Itens fixos da navegacao principal. Eles refletem a ordem de leitura pensada para o TCC.
const navItems = [
  { key: "dashboard", label: "Dashboard" },
  { key: "assessment", label: "Assessment" },
  { key: "results", label: "Results" },
  { key: "recommendations", label: "Recommendations" },
  { key: "history", label: "History" },
  { key: "settings", label: "Organization Settings" }
];

export function PlatformLayout({
  activePage,
  title,
  subtitle,
  organization,
  userName,
  onNavigate,
  onLogout,
  organizationOptions = [],
  selectedOrganizationId = "",
  onOrganizationChange,
  cycleOptions = [],
  selectedCycleId = "",
  onCycleChange,
  usingMockData = false,
  analyticsError = "",
  children
}) {
  return (
    <div className="platform-shell">
      {/* Sidebar com identidade visual e acesso rápido às páginas centrais. */}
      <aside className="platform-sidebar">
        <div className="platform-logo">
          <img src="/branding/logo-zeppelin.png" alt="Zeppelin" />
          <p>CI/CD Maturity</p>
        </div>

        <nav>
          {navItems.map((item) => (
            <button
              key={item.key}
              type="button"
              className={item.key === activePage ? "active" : ""}
              onClick={() => onNavigate(item.key)}
            >
              {item.label}
            </button>
          ))}
        </nav>

        <button className="logout-btn" type="button" onClick={onLogout}>
          Sign out
        </button>
      </aside>

      <section className="platform-main">
        {/* Topo com contexto da análise atual: empresa, página e ciclo selecionado. */}
        <header className="platform-topbar">
          <div>
            {organizationOptions.length > 1 && onOrganizationChange ? (
              <label className="topbar-control-inline">
                <select 
                  value={selectedOrganizationId} 
                  onChange={(event) => onOrganizationChange(event.target.value)}
                  className="org-select"
                >
                  {organizationOptions.map((item) => (
                    <option key={item.id} value={item.id}>
                      {item.name}
                    </option>
                  ))}
                </select>
              </label>
            ) : (
              <p>{organization}</p>
            )}
            <h1>{title}</h1>
            <small>{subtitle}</small>
          </div>
          <div className="topbar-actions">
            {cycleOptions.length > 0 && onCycleChange ? (
              // Permite trocar o ciclo avaliado sem sair da mesma pagina.
              <label className="topbar-control">
                <span>Assessment cycle</span>
                <select value={selectedCycleId} onChange={(event) => onCycleChange(event.target.value)}>
                  <option value="">Latest cycle</option>
                  {cycleOptions.map((item) => (
                    <option key={item.id} value={item.id}>
                      {item.shortLabel} - {item.label}
                    </option>
                  ))}
                </select>
              </label>
            ) : null}

            <div className="topbar-status">
              <div className="user-box">
                <span>{userName}</span>
              </div>
            </div>
          </div>
        </header>

        {analyticsError && usingMockData ? (
          // Se a API falhar, deixamos claro para o usuario o motivo da troca para dados demo.
          <div className="platform-banner">
            Showing fallback data because analytics could not be loaded from backend: {analyticsError}
          </div>
        ) : null}

        {/* Cada pagina do TCC e renderizada dentro desta area principal. */}
        <div className="platform-content">{children}</div>
      </section>
    </div>
  );
}
