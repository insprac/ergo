defmodule GitTest do
  use ExUnit.Case

  def gen_name do
    timestamp = DateTime.utc_now() |> DateTime.to_unix()
    unique_integer = System.unique_integer([:positive])
    "git_repo_test_#{timestamp}_#{unique_integer}"
  end

  setup do
    name = gen_name()
    path = System.tmp_dir() |> Path.join(name)
    origin = "git@github.com/insprac/#{name}"
    repo = %Git.Repo{name: name, path: path, origin: origin}
    {_, 0} = System.cmd("mkdir", [path])
    {:ok, repo: repo}
  end

  test "successfully returns version information", %{repo: repo} do
    assert {:ok, output} = Git.git(repo, :version)
    assert Regex.match?(~r/^git version \d+\.\d+\.\d+\n$/, output)
  end

  test "returns an error when an invalid command is given", %{repo: repo} do
    assert {:error, {1, _output}} = Git.git(repo, :invalid_cmd)
  end

  test "init, add files commit and log", %{repo: repo} do
    assert {:ok, _output} = Git.git(repo, :init)
    filename = "example_file.text"
    file_path = Path.join(repo.path, filename)
    {_output, 0} = System.cmd("touch", [file_path])
    assert {:ok, _output} = Git.git(repo, :add, [filename])
    assert {:ok, commit_output} = Git.git(repo, :commit, ["-m", "Test commit"])
    assert Regex.match?(~r/Test commit\n 1 file changed/, commit_output)
    assert {:ok, log_output} = Git.git(repo, :log)
    assert Regex.match?(~r/Test commit/, log_output)
  end
end
