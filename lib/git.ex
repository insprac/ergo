defmodule Git do
  @type command :: atom
  @type status_code :: non_neg_integer()
  @type output :: String.t

  @spec git(Git.Repo.t, command, Keyword.t)
  :: {:ok, output} | {:error, {status_code, output}}
  def git(%Git.Repo{} = repo, command, options \\ []) do
    case System.cmd("git", ["#{command}" | options], cd: repo.path) do
      {output, 0} -> {:ok, output}
      {output, status_code} -> {:error, {status_code, output}}
    end
  end
end
