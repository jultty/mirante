const form = document.getElementById('course_form')
const dialog = document.getElementById('user_dialog')

async function course_creation_handler(event) {
  event.preventDefault();
  dialog.innerText = ''

  const form_data = Object.fromEntries(new FormData(form));
  let token = JSON.parse(sessionStorage.getItem("mirante_credentials")).token

  console.log('token: ' + token)
  console.log(form_data)

  const response = await fetch('http://localhost:3031/course', {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${token}`,
    },
    body: JSON.stringify(form_data),
  })

  response_json = await response.json()
  console.dir(response_json)

  if (response.status == '403') {
    dialog.innerText = 'Permissão negada: ' + response_json.message
    return
  } else if (response.status == '201') {
    dialog.innerText = 'Curso criado'
  } else {
    dialog.innerText = 'Erro inesperado: ' + response_json.message
  }
}

form.addEventListener('submit', course_creation_handler)
