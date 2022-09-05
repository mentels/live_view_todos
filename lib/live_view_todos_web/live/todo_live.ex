defmodule LiveViewTodosWeb.TodoLive do
  use LiveViewTodosWeb, :live_view

  alias LiveViewTodos.Todos

  def mount(_params, _session, socket) do
    Todos.subscribe()
    {:ok, fetch(socket)}
  end

  def handle_event("add", %{"todo" => todo}, socket) do
    Todos.create_todo(todo)

    # we don't need to fetch, as we're receiving a PubSub event and then we fetch anyhow
    # {:noreply, fetch(socket)}
    {:noreply, socket}
  end

  def handle_event("toggle_done", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    Todos.update_todo(todo, %{done: !todo.done})

    # we don't need to fetch, as we're receiving a PubSub event and then we fetch anyhow
    # {:noreply, fetch(socket)}
    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    Todos.delete_todo(todo)
    {:noreply, socket}
  end

  def handle_info({Todos, [:todo | _], _}, socket) do
    {:noreply, fetch(socket)}
  end

  # the render/1 is not needed as the template as in the same dir as the live view code
  # def render(assigns) do
  #   ~L"Rendering LiveView"
  # end

  def fetch(socket), do: assign(socket, todos: Todos.list_todos())
end
