import { getAuthHeaders } from "./authHelper";
/**
 * Serviços de comunicação com a API do módulo de Questionário.
 */

// Função auxiliar para capturar o cookie CSRF do Django
function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== "") {
        const cookies = document.cookie.split(";");
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + "=")) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}

// Busca todos os Níveis de Adoção (Adopted Levels) disponíveis no banco
export async function getAdoptedLevels() {
    const response = await fetch("/api/questionnaire/adoptedlevel/?page_size=100", { headers: getAuthHeaders() });

    if (!response.ok) {
        throw new Error("Failed to fetch adopted levels");
    }
    
    const json = await response.json();
    return json.data; // O CustomPagination do projeto usa o campo 'data'
}

// Busca todas as 71 Perguntas (Statements) oficiais do questionário
export async function getStatements() {
    const response = await fetch("/api/questionnaire/statement/?page_size=100", { headers: getAuthHeaders() });

    if (!response.ok) {
        throw new Error("Failed to fetch statements");
    }

    const json = await response.json();
    return json.data;
}

// Busca as respostas salvas do usuário/organização atual no ciclo selecionado
export async function getSavedAnswers(organizationId, questionnaireId) {
    if (!organizationId) {
        throw new Error("organizationId is required to fetch saved answers");
    }

    let url = `/api/questionnaire/answer/?organization_answer=${organizationId}&page_size=1000`;
    
    if (questionnaireId) {
        url += `&questionnaire_answer=${questionnaireId}`;
    }

    const response = await fetch(url, { headers: getAuthHeaders() });

    if (!response.ok) {
        throw new Error("Failed to fetch saved answers");
    }

    const json = await response.json();
    return json.data;
}

// Cria um novo ciclo de questionário em branco
export async function createQuestionnaireCycle() {
    const csrftoken = getCookie("csrftoken");
    
    const payload = {
        applied_date: new Date().toISOString()
    };

    const response = await fetch("/api/questionnaire/questionnaire/", {
        method: "POST",
        headers: getAuthHeaders({
            "Content-Type": "application/json",
            "X-CSRFToken": csrftoken
        }),
        body: JSON.stringify(payload)
    });

    if (!response.ok) {
        throw new Error("Failed to create a new questionnaire cycle");
    }

    const data = await response.json();
    return data;
}

// Salva uma resposta individual do usuário
export async function saveAnswer(statementId, adoptedLevelId, organizationId, questionnaireId) {
    const csrftoken = getCookie("csrftoken");
    
    if (!organizationId) {
        throw new Error("organizationId is required to save an answer");
    }

    const payload = {
        statement_answer: statementId,
        adopted_level_answer: adoptedLevelId,
        comment_answer: "",
        organization_answer: organizationId,
        questionnaire_answer: questionnaireId || null
    };

    const response = await fetch("/api/questionnaire/answer/", {
        method: "POST",
        headers: getAuthHeaders({
            "Content-Type": "application/json",
            "X-CSRFToken": csrftoken
        }),
        body: JSON.stringify(payload)
    });

    if (!response.ok) {
        throw new Error("Failed to save answer");
    }

    return await response.json();
}
