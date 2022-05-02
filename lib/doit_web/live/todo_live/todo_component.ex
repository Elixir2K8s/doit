defmodule DoitWeb.TodoLive.TodoComponent do
    use DoitWeb, :live_component
    alias Doit.Todos

    def render(assigns) do
        #{if @todo.__meta__.state == :deleted do hidden end}
        ~H"""
        <div id={"todo-#{@todo.id}"} class={"todo max-w-sm rounded overflow-hidden shadow-lg #{if @todo.__meta__.state == :deleted do "hidden" end}"} >
            <div class="px-6 py-4">
                <div class="flex flex-wrap">
                    <div class="font-bold text-xl mb-2 flex-1">
                        <%= @todo.title %>
                    </div>
                    <div class="flex-none">
                        <%= checkbox(:todo, :done, phx_click: "toggle_done", phx_value_id: @todo.id, value: @todo.done, class: "px-4 py-4 rounded-full checked:bg-green-600") %>
                    </div>
                </div>

                <p class="text-gray-700 text-base h-8">
                    <%= @todo.description %>
                </p>
            </div>
            <div class="px-6 py-4">
            <!--<div class="flex">
                <div class="flex-auto px-4 py-2 m-2">-->
                    <div class="flex flex-wrap justify-between">
                        <div>
                        <span class="inline-block bg-gray-200 rounded-full px-3 py-1 text-sm font-semibold text-gray-700 mr-2 mb-2">#importance <%= @todo.importance %></span>
                        </div>
                        <div>
                            <button class="bg-transparent hover:bg-blue-500 text-blue-700 font-semibold hover:text-white px-2 border border-blue-500 hover:border-transparent rounded" phx-click="vote_up" phx-target={@myself}>+</button>
                            <button class="bg-transparent hover:bg-blue-500 text-blue-700 font-semibold hover:text-white px-2 border border-blue-500 hover:border-transparent rounded" phx-click="vote_down" phx-target={@myself}>-</button>
                        </div>
                    </div>
            <!--    </div>
                <div class="flex-auto px-4 py-2 m-2">-->

                <!--</div>
            </div>-->
            </div>
            <div class="px-6 pt-4 pb-2">
                <button class="bg-transparent hover:bg-green-500 text-green-700 font-semibold hover:text-white py-1 px-3 border border-green-500 hover:border-transparent rounded"><%= live_patch "Edit", to: Routes.todo_index_path(@socket, :edit, @todo.id) %></button>
                <button class="bg-transparent hover:bg-red-500 text-red-700 font-semibold hover:text-white py-1 px-3 border border-red-500 hover:border-transparent rounded"><%= link "Delete", to: "#", phx_click: "delete", phx_value_id: @todo.id, data: [confirm: "Are you sure?"] %></button>
            </div>
        </div>
        """
    end



    def handle_event("vote_up", _value, socket) do
        #event is handeled inside component via set the phx-target={@myself}
        {:ok, importance} = Todos.inc_importance(socket.assigns.id)
        {:noreply, assign(socket, :importance, importance)}
    end

    def handle_event("vote_down", _value, socket) do
        #event is handeled inside component via set the phx-target={@myself}
        {:ok, importance} = Todos.dec_importance(socket.assigns.id)
        {:noreply, assign(socket, :importance, importance)}
    end


    #def handle_event("toggle_done", %{"id" => id}, socket) do
    #    todo = Doit.Todos.get_todo!(id)
    #    Doit.Todos.update_todo(todo, %{done: !todo.done})
    #    #Doit.Todos.enc_importance(socket.assigns.todo)
    #    {:noreply, socket}
    #end

end
