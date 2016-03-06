Code.load_file("priority-queue.exs")

ExUnit.start
ExUnit.configure(exclude: [],
                 include: :last,
                 trace: true)

defmodule PriorityQueueTest do
  use ExUnit.Case#, async: true

  setup do
    {:ok, pid} = PriorityQueue.start_link()
    {:ok, [pid: pid]}
  end

  @tag :peekMin
  test "returns nil when peeking before enqueueing" do
    assert PriorityQueue.peekMin() == nil
  end

  @tag :peekMin
  @tag :enqueue
  test "returns first value if only enqueing one value" do
    PriorityQueue.enqueue(5)
    assert PriorityQueue.peekMin() == 5
  end

  @tag :peekMin
  @tag :enqueue
  test "returns min value after enqueing several values" do
    PriorityQueue.enqueue(5)
    PriorityQueue.enqueue(2)
    PriorityQueue.enqueue(4)
    assert PriorityQueue.peekMin() == 2
  end

  # @tag :takeMin
  @tag :peekMin
  test "it returns minimum value" do
    PriorityQueue.enqueue(5)
    PriorityQueue.enqueue(2)
    PriorityQueue.enqueue(4)
    assert PriorityQueue.takeMin() == 2
  end

  @tag :takeMin
  test "it removes minimum value and next min bubbles to top" do
    PriorityQueue.enqueue(5)
    PriorityQueue.enqueue(2)
    PriorityQueue.enqueue(50)
    PriorityQueue.enqueue(4)
    PriorityQueue.enqueue(45)
    PriorityQueue.enqueue(4)
    PriorityQueue.takeMin()
    assert PriorityQueue.peekMin() == 4
  end

  @tag :last
  test "it takes in a bunch of values and spits them out sorted" do
    randos = 1..1000
    |> Enum.into([], fn (r)-> :random.uniform(10000) end)
    Enum.each(randos, &PriorityQueue.enqueue(&1))
    popped_off_queue = Enum.map(randos, fn (r)->
      PriorityQueue.takeMin()
    end
    )
    assert Enum.sort(randos) == popped_off_queue
  end

  test "bubble down returns tuple of there are no children" do
    assert(PriorityQueue.bubble_down({3,1,2},1) == {3,1,2})
  end

  @tag :takeMin
  test 'swapping values' do
    tuple = {1,2,3}
    tuple2 = PriorityQueue.swap_values(
      tuple, 1, 2)
    assert tuple2 == {1,3,2}
  end
end
