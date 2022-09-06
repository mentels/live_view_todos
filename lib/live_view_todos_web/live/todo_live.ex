defmodule LiveViewTodosWeb.TodoLive do
  use LiveViewTodosWeb, :live_view
  # auto-imported in the previous line
  # use Phoenix.Component

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

  def todo_list(assigns) do
    ~H"""
    <%= for todo <- @todos do %>
      <div>
        <%= checkbox(:todo, :done, phx_click: "toggle_done", phx_value_id: todo.id, value: todo.done) %>
        <%= todo.title %>
        <%= submit "Delete", phx_click: "delete", phx_value_id: todo.id %>
      </div>
    <% end %>
    """
  end

  def todo_list_slot(assigns) do
    ~H"""
    <%= for todo <- @todos do %>
      <%= render_slot(
        @inner_block,
        %{checkbox: tickbox(todo.id, todo.done), title: todo.title, delete_button: delete_button(todo.id)}
        )
      %>
    <% end %>
    """
  end


  defp fetch(socket), do: assign(socket, todos: Todos.list_todos())

  defp tickbox(id, value),
    do: checkbox(:todo, :done, phx_click: "toggle_done", phx_value_id: id, value: value)

  defp delete_button(id), do: submit("Delete", phx_click: "delete", phx_value_id: id)
end
