defmodule HubStorage do

  use GenServer
  require Logger

  def start(args) do
    GenServer.start __MODULE__, args, []
  end

  def init(args) do
    path = Dict.get(args, :path, nil)
    values = Dict.get(args, :values, [])
    type = Dict.get(args, :type, "hub_storage")

    case path do
      nil -> {:stop, :no_path}
      path ->
        #Retrieve previous information from PersistentStorage
        data = PersistentStorage.get(pstore_point(path), ["@type": type])

        #merge new values with Persistent data
        data = data ++ values

        #Setup the hub and manage the point
        Hub.put path, data
        Hub.master path

        {:ok, %{path: path}}
    end
  end

  def handle_call({:request, path, params, _}, _, state) do
    # BUGBUG: Does Hub protect against attacks (ie: to much data)?
    reply = Hub.put path, params
    {{_,_}, updated} = Hub.fetch(Dict.get(state, :path))
    PersistentStorage.put pstore_point(Dict.get(state, :path)), updated
    {:reply, reply, state}
  end

  # Convert list of atoms to binaries
  defp binarify([h|t]), do: List.flatten [binarify(h), binarify(t)]
  defp binarify(a) when is_atom(a), do: Atom.to_string(a)
  defp binarify(o), do: o

  # Compute PersistentStorage file name
  def sp_name(path) do
    Enum.join(binarify([:hub_storage | path]), "_")
  end

  # Compute PersistentStorage file name to atom
  def pstore_point(path) do
    String.to_atom sp_name(path)
  end
end
