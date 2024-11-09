const form = document.getElementById('course_form')
const table = document.getElementById('course_table')
const dialog = document.getElementById('user_dialog')

// AUTHENTICATION

function authenticate() {
  const stored_credentials = sessionStorage.getItem("mirante_credentials")

  if (stored_credentials)
    return JSON.parse(stored_credentials).token
}

// GET

async function update(_) {

  clearChildren(table.id)

  const token = authenticate()
  let response

  try {

    response = await fetch('http://localhost:3031/course', {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`,
      },
    })

  } catch(error) {

    console.log(error)
    dialog.innerText = 'Erro ao obter cursos'
    return

  }

  if (response.status == 200) {

    const json = await response.json()

    json.forEach(course => {

      const new_row = document.createElement('tr')

      const checkbox_cell = document.createElement('td')
      const checkbox = document.createElement('input')
      checkbox.type = 'checkbox'
      checkbox.id = `course_${course.id}_checkbox`
      checkbox.class = 'course_checkbox'
      checkbox_cell.appendChild(checkbox)
      new_row.appendChild(checkbox_cell)

      const text_cell = document.createElement('td')
      text_cell.innerText = course.name
      new_row.appendChild(text_cell)

      const edit_cell = document.createElement('td')
      const edit_button = document.createElement('button')
      edit_button.innerText = 'Editar'
      edit_button.class = 'course_edit_button'
      edit_button.id = `course_${course.id}_edit_button`
      edit_cell.appendChild(edit_button)
      new_row.appendChild(edit_cell)

      table.appendChild(new_row)

    })

  } else if (response.status == 401) {
    dialog.innerText = 'Erro ao obter cursos: Não autorizado'
  } else {
    dialog.innerText = `Erro ${response.status} inesperado ao obter cursos: ${response}`
  }

}

window.addEventListener('load', update)

// POST

async function create(event) {

  event.preventDefault();
  dialog.innerText = ''

  const token = authenticate()
  const form_data = Object.fromEntries(new FormData(form))
  let response

  try {
    response = await fetch('http://localhost:3031/course', {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": `Bearer ${token}`,
      },
      body: JSON.stringify(form_data),
    })
  } catch(error) {
    console.log(error)
    dialog.innerText = 'Erro na requisição'
    return
  }

  await update()

  if (response) {
    console.log(response)
  }

  if (response.status == '403' || response.status == '401') {
    dialog.innerText = 'Permissão negada: '
    return
  } else if (response.status == '201') {
    dialog.innerText = 'Curso criado com sucesso'
    update(event)
  } else {
    dialog.innerText = `Erro ${response.status} inesperado: ${response.statusText}`
  }
}

form.addEventListener('submit', create)

window.addEventListener('load', () => {

    const header_row = document.createElement('tr')

    const checkbox_header = document.createElement('th')
    checkbox_header.id = 'checkbox_header'
    const select_all_checkbox = document.createElement('input')
    select_all_checkbox.type = 'checkbox'
    select_all_checkbox.id = 'select_all_checkbox'
    checkbox_header.appendChild(select_all_checkbox)

    const course_name_header = document.createElement('th')
    course_name_header.id = 'course_name_header'
    course_name_header.innerText = 'Nome'

    const edit_header = document.createElement('th')
    edit_header.id = 'edit_header'
    edit_header.innerText = 'Editar'

    header_row.append(checkbox_header, course_name_header, edit_header)
    table.appendChild(header_row)

    const delete_button = document.createElement('button')
    delete_button.id = 'delete_button'
    delete_button.innerText = 'Excluir seleção'

    table.after(delete_button)

})
