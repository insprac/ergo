defmodule Git.Repo do
  defstruct [:name, :path, :origin]

  @type name :: String.t
  @type path :: String.t
  @type origin :: String.t

  @type t :: %__MODULE__{
    name: name,
    path: path,
    origin: origin
  }
end
