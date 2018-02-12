defmodule ExDiff do
  @flags %{
    ins: "+",
    del: "-",
    eq: " "
  }

  @moduledoc """
  Documentation for ExDiff.
  """

  @doc ~S{diff strings before splited by new line

## Example

```
iex(35)> ExDiff.diff_texts("""
...(35)> 1
...(35)> 4
...(35)> 2
...(35)> 3
...(35)> """,
...(35)> """
...(35)> 1
...(35)> 2
...(35)> 3
...(35)> 4
...(35)> """)
[" 1", "-4", " 2", " 3", "+4", " "]
```
}
  def diff_texts(text1, text2) do
    ss1 = String.split(text1, "\n")
    ss2 = String.split(text2, "\n")

    List.myers_difference(ss1, ss2)
    |> format()
  end

  @doc """
  format diff result

  ## Example

  ```
  iex> ExDiff.format([eq: [1], del: [4], eq: [2, 3], ins: [4]])
  [" 1", "-4", " 2", " 3", "+4"]
  ```
  """
  def format(result) do
    format(result, [])
  end

  defp format([], acc) do
    Enum.reverse(acc)
  end

  defp format([{key, els}|rest], acc) when key in [:ins, :del, :eq] do
    format(rest, Enum.reduce(els, acc, &["#{@flags[key]}#{&1}"|&2]))
  end
end
