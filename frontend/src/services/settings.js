import { getAuthHeaders } from "./authHelper";
const API_BASE = import.meta.env.VITE_API_BASE_URL || import.meta.env.VITE_API_URL || "";

function getCookie(name) {
  let cookieValue = null;
  if (document.cookie && document.cookie !== "") {
    const cookies = document.cookie.split(";");
    for (let index = 0; index < cookies.length; index += 1) {
      const cookie = cookies[index].trim();
      if (cookie.substring(0, name.length + 1) === `${name}=`) {
        cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
        break;
      }
    }
  }
  return cookieValue;
}

async function parseResponse(response, fallbackMessage) {
  const data = await response.json().catch(() => ({}));

  if (!response.ok) {
    const message =
      data.error || data.detail || data.message || `${fallbackMessage} (status ${response.status})`;
    throw new Error(message);
  }

  return data;
}

export async function loadOrganizationSettings(organizationId) {
  if (!organizationId) {
    throw new Error("organizationId is required");
  }

  const response = await fetch(
    `${API_BASE}/auth/organization-settings/?organization_id=${organizationId}`,
    {
      credentials: "include",
    }
  );

  return parseResponse(response, "Failed to load organization settings.");
}

export async function deleteOrganizationMember(memberId) {
  const response = await fetch(`${API_BASE}/auth/organization-settings/members/${memberId}/`, {
    method: "DELETE",
    credentials: "include",
    headers: getAuthHeaders({
      "X-CSRFToken": getCookie("csrftoken"),
    }),
  });

  return parseResponse(response, "Failed to remove member.");
}

export async function updateCurrentUserProfile(payload) {
  const response = await fetch(`${API_BASE}/auth/profile/`, {
    method: "PATCH",
    credentials: "include",
    headers: getAuthHeaders({
      "Content-Type": "application/json",
      "X-CSRFToken": getCookie("csrftoken"),
    }),
    body: JSON.stringify(payload),
  });

  return parseResponse(response, "Failed to update profile.");
}
