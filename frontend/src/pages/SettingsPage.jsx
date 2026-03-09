export function SettingsPage() {
  return (
    <>
      <section className="panel">
        <h3>Organization Profile</h3>
        <div className="grid-3">
          <label>
            Organization Name
            <input defaultValue="Zeppelin Labs" />
          </label>
          <label>
            Industry
            <input defaultValue="Software & Technology" />
          </label>
          <label>
            Team Size
            <input defaultValue="140 engineers" />
          </label>
        </div>
      </section>

      <section className="panel">
        <h3>User Profile</h3>
        <div className="grid-3">
          <label>
            Full Name
            <input defaultValue="Alex Silva" />
          </label>
          <label>
            Email
            <input defaultValue="alex@zeppelinlabs.com" />
          </label>
          <label>
            Role
            <input defaultValue="Engineering Manager" />
          </label>
        </div>
        <div className="btn-row" style={{ marginTop: "1rem" }}>
          <button className="btn-secondary-ui" type="button">
            Cancel
          </button>
          <button className="btn-primary-ui" type="button">
            Save Changes
          </button>
        </div>
      </section>
    </>
  );
}
