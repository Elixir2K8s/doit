defmodule DoitWeb.TodoLive.Index do
  use DoitWeb, :live_view

  alias Doit.Todos
  alias Doit.Todos.Todo

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Todos.subscribe()

    self_node = inspect(node())
    nodes = inspect Node.list()

    #initialy %Todo{} = todo
    changeset = Todos.change_todo(%Todo{})

    {:ok,
     socket
     |> assign(:todos, list_todos(session))
     |> assign(:changeset, changeset)
     |> assign(:node, self_node)
     |> assign(:nodes, nodes)
     |> assign(:session, session),
     temporary_assigns: [todos: []]}

    #{:ok, assign(socket, :todos, list_todos()), temporary_assigns: [todos: []]}
    #{:ok, assign(socket, :todos, list_todos())}
    #get pictures from wikidata
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def handle_params(%{"sort_by" => sort_by}, _uri, socket) do
    case sort_by do
      sort_by
      when sort_by in ~w(importance) ->
        {:noreply, assign(socket, todos: sort_todos(socket.assigns.todos, sort_by))}

      _ ->
        {:noreply, socket}
    end
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Todo")
    |> assign(:todo, Todos.get_todo!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Todo")
    |> assign(:todo, %Todo{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Todos")
    |> assign(:todo, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do

    #todo = Todos.get_todo!(id)
    #case Todos.delete_todo(todo) do
    #  {:ok, todo} ->
    #    send(self(), {:todo_deleted, todo})

    #    {:noreply,
    #    socket
    #    |> put_flash(:info, "Todo deleted successfully")
    #    |> push_patch(to: Routes.todo_index_path(socket, :index))}


    #  {:error, changeset} ->
    #    {:noreply, assign(socket, :changeset, changeset)}

    todo = Todos.get_todo!(id)
    {:ok, _} = Todos.delete_todo(todo)

    #{:noreply, socket}
    {:noreply,
    socket
    |> put_flash(:info, "Todo deleted successfully")}


    #IO.puts("---- delete ---------")
    #{:noreply, assign(socket, :todos, list_todos())}
  end

  def handle_event("validate", %{"todo" => todo_params}, socket) do
    IO.puts(inspect todo_params)
    changeset =
      %Todo{}
      |> Todos.change_todo(todo_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"todo" => todo_params}, socket) do
    case Todos.create_todo(todo_params, socket.assigns.session) do
      {:ok, _todo} ->
        #reassign an empty change set to clear the input
        changeset = Todos.change_todo(%Todo{})
        {:noreply,
         socket
         |> put_flash(:info, "Todo created successfully")
         |> assign(:changeset, changeset)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("toggle_done", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    Todos.update_todo(todo, %{done: !todo.done})
    #Doit.Todos.enc_importance(socket.assigns.todo)
    {:noreply, socket}
  end

  @impl true
  @spec handle_info(
          {:todo_created, any}
          | {:todo_deleted, any}
          | {:todo_updated, any}
          | {:todo_updated_importance, any},
          map
        ) :: {:noreply, map}
  def handle_info({:todo_created, todo}, socket) do
    #All of the data in a LiveView is stored in the socket as assigns
    #slow version
    #{:noreply, assign(socket, :todos, list_todos())}
    #fast version -> prepend the new created todo to the List of Todos
    {:noreply, update(socket, :todos, fn todos -> [todo | todos] end)}
    #{:noreply, update(socket, :todos, Enum.sort([todo | socket.assigns.todos], &(&1.importance > &2.importance)))}
  end

  def handle_info({:todo_updated, todo}, socket) do
    {:noreply, update(socket, :todos, fn todos -> [todo | todos] end)}
  end

  def handle_info({:todo_updated_importance, todo}, socket) do
    #IO.puts("#{inspectsocket.assigns.todos")
    #{:noreply, assign(socket, :todos, Enum.sort_by(socket.assigns.todos, &(&1.importance)))}
    #{:noreply, assign(socket, :todos, list_todos())}
    #{:noreply, update(socket, :todos, fn todos -> [todo | todos] end)}
    {:noreply, update(socket, :todos, fn todos -> [todo | todos] end)}
  end


  def sort_todos(todos, "importance") do
    Enum.sort_by(todos, fn todo -> todo.importance end)
  end


  def handle_info({:todo_deleted, todo}, socket) do
    #IO.puts "----------------Delete me---------------------"
    {:noreply, update(socket, :todos, fn todos -> [todo | todos] end)}
  end

  defp list_todos(session) do
    Todos.list_todos(session)
  end
end
