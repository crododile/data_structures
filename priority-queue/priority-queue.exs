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
    last = elem(tuple, last_index)
    tuple
    |> Tuple.delete_at(last_index)
    |> Tuple.delete_at(0)
    |> Tuple.insert_at(0, last)
    |> bubble_down
  end

  defp bubble_down(tuple) do
    bubble_down(tuple, 0)
  end

  defp bubble_down(tuple, current_index) do
    left_child_index = current_index * 2 + 1
    right_child_index = left_child_index + 1
    last_index = tuple_size(tuple) - 1
    current_value = elem(tuple, current_index)
    swap_index = left_child_index

    if last_index >= right_child_index do
      if elem(tuple, right_child_index) < elem(tuple, left_child_index) do
        swap_index = right_child_index
      end
    end
    if last_index >= swap_index && elem(tuple, swap_index) < current_value do
      swap_values(tuple, current_index, swap_index)
      |> bubble_down(swap_index)
    else
      tuple
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
    item = elem(tuple, index)
    parent = elem(tuple, parent_index)
    if item < parent do
      tuple
      |> swap_values(index, parent_index)
      |> bubble_up(parent_index)
    else
      tuple
    end
  end

  defp peekMin(tuple) do
    if tuple_size(tuple) == 0 do
      nil
    else
      elem(tuple, 0)
    end
  end

end
