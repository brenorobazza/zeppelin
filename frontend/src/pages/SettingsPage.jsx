import { useEffect, useState } from "react";
import {
  deleteOrganizationMember,
  loadOrganizationSettings,
  updateCurrentUserProfile,
} from "../services/settings";

export function SettingsPage({ organizationId, onProfileUpdated, onSelfRemoved }) {
  const [settings, setSettings] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [feedback, setFeedback] = useState("");
  const [deletingId, setDeletingId] = useState(null);
  const [isSavingProfile, setIsSavingProfile] = useState(false);
  const [profileForm, setProfileForm] = useState({
    firstName: "",
    lastName: "",
  });

  useEffect(() => {
    if (!organizationId) {
      setSettings(null);
      setError("");
      setFeedback("");
      return;
    }

    let ignore = false;

    async function syncSettings() {
      setLoading(true);
      setError("");
      setFeedback("");

      try {
        const payload = await loadOrganizationSettings(organizationId);
        if (!ignore) {
          setSettings(payload);
          setProfileForm({
            firstName: payload.current_user?.first_name || "",
            lastName: payload.current_user?.last_name || "",
          });
        }
      } catch (requestError) {
        if (!ignore) {
          setSettings(null);
          setError(requestError.message);
        }
      } finally {
        if (!ignore) {
          setLoading(false);
        }
      }
    }

    syncSettings();
    return () => {
      ignore = true;
    };
  }, [organizationId]);

  function handleProfileChange(event) {
    const { name, value } = event.target;
    setProfileForm((current) => ({
      ...current,
      [name]: value,
    }));
  }

  async function handleProfileSubmit(event) {
    event.preventDefault();
    setError("");
    setFeedback("");
    setIsSavingProfile(true);

    try {
      const payload = await updateCurrentUserProfile({
        first_name: profileForm.firstName,
        last_name: profileForm.lastName,
      });

      setSettings((current) => {
        if (!current) return current;
        return {
          ...current,
          current_user: {
            ...current.current_user,
            first_name: payload.first_name,
            last_name: payload.last_name,
            full_name: payload.full_name,
          },
          members: current.members.map((member) =>
            member.is_current_user
              ? {
                  ...member,
                  name: payload.full_name,
                }
              : member
          ),
        };
      });
      setProfileForm({
        firstName: payload.first_name || "",
        lastName: payload.last_name || "",
      });
      setFeedback("Your name was updated.");

      if (typeof onProfileUpdated === "function") {
        onProfileUpdated({
          username: payload.username,
          fullName: payload.full_name,
          email: payload.email,
        });
      }
    } catch (requestError) {
      setError(requestError.message);
    } finally {
      setIsSavingProfile(false);
    }
  }

  async function handleDeleteMember(member) {
    const confirmationMessage = member.is_current_user
      ? "Remove your access to this organization?"
      : `Remove ${member.name} from this organization?`;

    if (!window.confirm(confirmationMessage)) {
      return;
    }

    setDeletingId(member.id);
    setError("");
    setFeedback("");

    try {
      const payload = await deleteOrganizationMember(member.id);

      if (payload.deleted_self) {
        setFeedback("Your access to this organization was removed.");
        if (typeof onSelfRemoved === "function") {
          onSelfRemoved();
        }
        return;
      }

      setSettings((current) => {
        if (!current) return current;
        return {
          ...current,
          organization: {
            ...current.organization,
            member_count: Math.max(0, (current.organization.member_count || 1) - 1),
          },
          members: current.members.filter((item) => item.id !== member.id),
        };
      });
      setFeedback(`${member.name} was removed from the organization.`);
    } catch (requestError) {
      setError(requestError.message);
    } finally {
      setDeletingId(null);
    }
  }

  if (!organizationId) {
    return (
      <section className="panel">
        <div className="empty-state">
          Select an organization to review members and manage removal permissions.
        </div>
      </section>
    );
  }

  if (loading) {
    return (
      <section className="panel">
        <p>Loading organization settings...</p>
      </section>
    );
  }

  if (error) {
    return (
      <section className="panel">
        <p className="feedback error">{error}</p>
      </section>
    );
  }

  if (!settings) {
    return (
      <section className="panel">
        <div className="empty-state">Organization settings are not available yet.</div>
      </section>
    );
  }

  const { organization, current_user: currentUser, members } = settings;

  return (
    <>
      <section className="panel">
        <div className="section-head">
          <div>
            <p className="eyebrow">Organization overview</p>
            <h3>Current organization context</h3>
            <p>
              Review the active organization and the member-removal rule applied in this workspace.
            </p>
          </div>
        </div>

        {feedback ? <p className="feedback success">{feedback}</p> : null}

        <div className="grid-3">
          <div className="context-card">
            <span>Organization</span>
            <strong>{organization.name}</strong>
          </div>
          <div className="context-card">
            <span>Members</span>
            <strong>{organization.member_count}</strong>
          </div>
          <div className="context-card">
            <span>Your access level</span>
            <strong>{currentUser.is_admin ? "Admin" : "Standard member"}</strong>
          </div>
        </div>

        <p className="settings-rule">
          You can remove your own membership. Removing another member requires admin privileges.
        </p>
      </section>

      <section className="panel">
        <div className="section-head">
          <div>
            <p className="eyebrow">Your membership</p>
            <h3>Current user</h3>
            <p>This section identifies the account linked to the current session and lets you update your displayed name.</p>
          </div>
        </div>

        <div className="grid-3">
          <div className="context-card">
            <span>Full name</span>
            <strong>{currentUser.full_name || currentUser.username}</strong>
          </div>
          <div className="context-card">
            <span>Email</span>
            <strong>{currentUser.email || "Not available"}</strong>
          </div>
          <div className="context-card">
            <span>Username</span>
            <strong>{currentUser.username}</strong>
          </div>
        </div>

        <div className="grid-3" style={{ marginTop: "0.75rem" }}>
          <div className="context-card">
            <span>Organization role</span>
            <strong>{currentUser.role || "Not defined"}</strong>
          </div>
          <div className="context-card">
            <span>Permission</span>
            <strong>{currentUser.is_admin ? "Can remove any member" : "Can remove only self"}</strong>
          </div>
          <div className="context-card">
            <span>Account status</span>
            <strong>Active</strong>
          </div>
        </div>

        <form className="settings-profile-form" onSubmit={handleProfileSubmit}>
          <div className="grid-3">
            <label>
              First name
              <input
                name="firstName"
                type="text"
                value={profileForm.firstName}
                onChange={handleProfileChange}
                placeholder="First name"
              />
            </label>
            <label>
              Last name
              <input
                name="lastName"
                type="text"
                value={profileForm.lastName}
                onChange={handleProfileChange}
                placeholder="Last name"
              />
            </label>
            <div className="settings-profile-form__actions">
              <button className="btn-primary-ui" type="submit" disabled={isSavingProfile}>
                {isSavingProfile ? "Saving..." : "Save name"}
              </button>
            </div>
          </div>
        </form>
      </section>

      <section className="panel">
        <div className="section-head">
          <div>
            <p className="eyebrow">Organization members</p>
            <h3>Member access</h3>
            <p>
              Remove memberships directly from this list. Buttons are enabled only when the current
              rule allows the action.
            </p>
          </div>
        </div>

        <div className="settings-member-list">
          {members.map((member) => (
            <article key={member.id} className="settings-member-card">
              <div className="settings-member-card__head">
                <div>
                  <h4>{member.name}</h4>
                  <p>{member.email || "Email not available"}</p>
                </div>
                <div className="btn-row">
                  {member.is_current_user ? <span className="tag">You</span> : null}
                  {member.role ? <span className="tag">{member.role}</span> : null}
                </div>
              </div>

              <div className="settings-member-card__meta">
                <div>
                  <span>Removal permission</span>
                  <strong>
                    {member.can_delete
                      ? member.is_current_user
                        ? "You can remove this membership"
                        : "Admin removal allowed"
                      : "Admin privileges required"}
                  </strong>
                </div>

                <button
                  className="btn-secondary-ui"
                  type="button"
                  disabled={!member.can_delete || deletingId === member.id}
                  onClick={() => handleDeleteMember(member)}
                >
                  {deletingId === member.id
                    ? "Removing..."
                    : member.is_current_user
                      ? "Remove me"
                      : member.can_delete
                        ? "Remove member"
                        : "Admin only"}
                </button>
              </div>
            </article>
          ))}
        </div>
      </section>
    </>
  );
}
