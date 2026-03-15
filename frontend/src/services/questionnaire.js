/**
 * Servicos de comunicacao com a API do modulo de Questionario.
 */

// Funcao auxiliar para capturar o cookie CSRF do Django
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

// Busca todos os Niveis de Adocao (Adopted Levels) disponiveis no banco
export async function getAdoptedLevels() {
    const response = await fetch("/api/questionnaire/adoptedlevel/?limit=100");

    if (!response.ok) {
        throw new Error("Failed to fetch adopted levels");
    }
    
    const json = await response.json();
    return json.data; // O CustomPagination do projeto usa o campo 'data'
}

// Busca todas as 71 Perguntas (Statements) oficiais do questionario
export async function getStatements() {
    const response = await fetch("/api/questionnaire/statement/?limit=100");

    if (!response.ok) {
        throw new Error("Failed to fetch statements");
    }

    const json = await response.json();
    return json.data;
}

// Salva uma resposta individual do usuario
export async function saveAnswer(statementId, adoptedLevelId) {
    const csrftoken = getCookie("csrftoken");
    const userOrgId = localStorage.getItem("organization_id");
    
    const payload = {
        statement_answer: statementId,
        adopted_level_answer: adoptedLevelId,
        comment_answer: "",
        organization_answer: userOrgId || 1
    };

    const response = await fetch("/api/questionnaire/answer/", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "X-CSRFToken": csrftoken
        },
        body: JSON.stringify(payload)
    });

    if (!response.ok) {
        throw new Error("Failed to save answer");
    }

    return await response.json();
}
