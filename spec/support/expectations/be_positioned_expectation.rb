RSpec::Matchers.define :be_positioned do |expected|
  match do |actual|
    tasks = actual.order(position: :asc)

    @starting_with ||= 1

    tasks.each_with_index.reduce(true) do |acc, (task, idx)|
      acc && (task.position == (idx + @starting_with))
    end
  end

  chain :starting_with do |starting_with|
    @starting_with = starting_with
  end

  failure_message do |actual|
    "expected that each successive task would have the position set to an increasing value"
  end
  
  failure_message_when_negated do |actual|
    "expected that each successive task would not have the position set to an increasing value"
  end
end
