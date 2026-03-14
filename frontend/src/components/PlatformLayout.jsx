import "./platform-layout.css";

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
  cycleOptions = [],
  selectedCycleId = "",
  onCycleChange,
  usingMockData = false,
  analyticsError = "",
  children
}) {
  return (
    <div className="platform-shell">
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
        <header className="platform-topbar">
          <div>
            <p>{organization}</p>
            <h1>{title}</h1>
            <small>{subtitle}</small>
          </div>
          <div className="topbar-actions">
            {cycleOptions.length > 0 && onCycleChange ? (
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
              <span className={`topbar-badge ${usingMockData ? "mock" : "live"}`}>
                {usingMockData ? "Demo data" : "Backend data"}
              </span>
              <div className="user-box">
                <span>{userName}</span>
              </div>
            </div>
          </div>
        </header>

        {analyticsError && usingMockData ? (
          <div className="platform-banner">
            Showing fallback data because analytics could not be loaded from backend: {analyticsError}
          </div>
        ) : null}

        <div className="platform-content">{children}</div>
      </section>
    </div>
  );
}
