defmodule PriorityQueue do
  def start_link do
    Agent.start_link(fn -> {} end, name: __MODULE__ )
  end

  def enqueue(item) do
    Agent.update(__MODULE__, &enqueue(&1, item))
  end

  def state do
    Agent.get(__MODULE__, &(&1))
  end

  def peekMin do
    Agent.get(__MODULE__, &peekMin(&1))
  end

  def takeMin do
    min = peekMin()
    Agent.update(__MODULE__, &removeMin(&1))
    min
  end

  defp removeMin(tuple) do
    last_index = tuple_size(tuple) - 1
    tuple
    |> swap_values(last_index, 0)
    |> Tuple.delete_at(last_index)
    |> bubble_down
  end

  defp bubble_down(tuple), do: bubble_down(tuple, 0)
  defp bubble_down(tuple, current_index) when tuple_size(tuple) <= (current_index * 2) do
    # no children
    tuple
  end
  defp bubble_down(tuple, current_index) do
    current_value = elem(tuple, current_index)
    swap_index = find_largest_child(tuple, current_index)

    if elem(tuple, swap_index) < current_value do
      swap_values(tuple, current_index, swap_index)
      |> bubble_down(swap_index)
    else
      tuple
    end
  end

  defp find_largest_child(tuple, parent_index) do
    left_child_index = parent_index * 2 + 1
    right_child_index = left_child_index + 1
    cond do
      # no right child
      tuple_size(tuple) <= right_child_index ->
        left_child_index
      # left < right
      elem(tuple, left_child_index) <= elem(tuple, right_child_index) ->
          left_child_index
      # else..
      true -> right_child_index
    end
  end

  def swap_values(tuple, index1, index2)  do
    value1 = elem(tuple, index1)
    value2 = elem(tuple, index2)
    tuple
    |> replace(index1, value2)
    |> replace(index2, value1)
  end

  defp replace(tuple, index, value) do
    tuple
    |> Tuple.delete_at(index)
    |> Tuple.insert_at(index, value)
  end

  defp enqueue(tuple, item) do
    tuple
    |> Tuple.append(item)
    |> bubble_up
  end

  defp bubble_up(tuple) do
    bubble_up(tuple, tuple_size(tuple) - 1)
  end

  defp bubble_up(tuple, index) do
    parent_index = div(index, 2)
    if elem(tuple, index) < elem(tuple, parent_index) do
      tuple
      |> swap_values(index, parent_index)
      |> bubble_up(parent_index)
    else
      tuple
    end
  end

  defp peekMin(tuple) when tuple_size(tuple) == 0, do: nil
  defp peekMin(tuple), do: elem(tuple, 0)
end
