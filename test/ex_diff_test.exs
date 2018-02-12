defmodule ExDiffTest do
  use ExUnit.Case
  doctest ExDiff

  test "eq" do
    assert ExDiff.format([eq: [1, 2, 3]]) == [" 1", " 2", " 3"]
  end

  test "del" do
    assert ExDiff.format([del: [1, 2, 3]]) == ["-1", "-2", "-3"]
  end

  test "ins" do
    assert ExDiff.format([ins: [1, 2, 3]]) == ["+1", "+2", "+3"]
  end
end
