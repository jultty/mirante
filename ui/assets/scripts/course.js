const form = document.getElementById('course_form')
const dialog = document.getElementById('user_dialog')

async function course_creation_handler(event) {
  event.preventDefault();
  dialog.innerText = ''

  const form_data = Object.fromEntries(new FormData(form));
  const stored_credentials = sessionStorage.getItem("mirante_credentials")
  let token

  if (stored_credentials)
    token = JSON.parse(stored_credentials).token

  const response = await fetch('http://localhost:3031/course', {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${token}`,
    },
    body: JSON.stringify(form_data),
  })

  console.dir(response)

  if (response.status == '403') {
    dialog.innerText = 'Permissão negada: ' + response_json.message
    return
  } else if (response.status == '201') {
    dialog.innerText = 'Curso criado com sucesso'
  } else {
    dialog.innerText = 'Erro inesperado: ' + response_json.message
  }
}

form.addEventListener('submit', course_creation_handler)
