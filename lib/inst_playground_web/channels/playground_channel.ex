defmodule InstPlaygroundWeb.PlaygroundChannel do
  use InstPlaygroundWeb, :channel

  def join("playground:global", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("note", payload, socket) do
    broadcast socket, "note", payload
    {:noreply, socket}
  end

  def handle_in("update", payload, socket) do
    broadcast socket, "update", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
