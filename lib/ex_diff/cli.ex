defmodule ExDiff.CLI do
  @option [
    strict: [
      color: :boolean,
      help: :boolean
    ],
    aliases: [
      c: :color,
      h: :help
    ]
  ]

  @doc """
  diff two files
  """
  def main(args) do
    result =
      with {:ok, file1, file2, colored} <- parse_option(args),
           {:ok, text1, text2} <- read_files(file1, file2),
           result <- ExDiff.diff_texts(text1, text2),
           do: {:ok, file1, file2, result, colored}

    puts_result(result)
  end

  @doc """
  parse command line option
  """
  def parse_option([]) do
    {:help}
  end

  def parse_option(args) do
    case OptionParser.parse(args, @option) do
    {[help: true], _, _} -> {:help}
    {[], [file1, file2], []} -> {:ok, file1, file2, false}
    {[color: colored], [file1, file2], []} -> {:ok, file1, file2, colored}
    {_, [_, _], errors} -> {:error, invalid_options: errors}
    {_, files, []} -> {:error, invalid_file_count: files}
    end
  end

  def read_files(file1, file2) do
    result1 = File.read(file1)
    result2 = File.read(file2)

    case [result1, result2] do
    [{:ok, text1}, {:ok, text2}] -> {:ok, text1, text2}
    error_result -> reasons = error_result
                              |> Enum.zip([file1, file2])
                              |> Enum.filter(fn {{state, _}, _} -> state == :error end)
                              |> Enum.map(fn {{_, reason}, filename} -> {reason, filename} end)
                    {:error, reasons}
    end
  end

  def puts_result({:ok, file1, file2, result, colored}) do
    IO.puts """
    --- #{file1}
    +++ #{file2}
    """

    result
    |> Enum.each(&puts_colored(&1, colored))
  end

  def puts_result({:error, reasons}) do
    IO.puts """
    ERROR: #{error_message(reasons)}
    """
    puts_result({:help})
  end

  def puts_result({:help}) do
    IO.puts """
    USAGE

    ex_diff [option] file1 file2
      --color, -c   colorize
      --no-color    non-colorize (default)
    """
  end

  @doc """
  Build error message from error status.

  - `:invalid_options` - invliad option found
  - `:invalid_file_count` - too few or too many file count
  - `:enoent` - file not exist
  - `:eacces` - file not accessable
  - `:eisdir` - it's directosy
  - `:enomem` - not enough memory to read file
  - otherwise - unknown error
  """
  def error_message(reasons) do
    reasons
    |> Enum.map(fn
      {:invalid_options, options} -> "invalid option: #{Enum.map(options, &elem(&1, 0)) |> Enum.join(", ")}"
      {:invalid_file_count, _} -> "must be given two file"
      {:enoent, filename} -> "#{filename} does not exist"
      {:eacces, filename} -> "cannot access to #{filename}"
      {:eisdir, filename} -> "#{filename} is directory"
      {:enomem, filename} -> "not enough memory to read #{filename}"
      _ -> "UNKNWON ERROR OCCURRED"
    end)
    |> Enum.join(", ")
  end

  defp puts_colored(s, false), do: IO.puts(s)
  defp puts_colored(<<?+, _::binary>> = s, true), do: IO.puts(green(s))
  defp puts_colored(<<?-, _::binary>> = s, true), do: IO.puts(red(s))
  defp puts_colored(<<?\s, _::binary>> = s, true), do: IO.puts(s)

  defp red(s), do: "\x1b[31m#{s}\x1b[m"
  defp green(s), do: "\x1b[32m#{s}\x1b[m"
end
