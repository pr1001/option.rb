# option.rb

Because `nil` stinks and I'm tired of `NoMethodError: undefined method '[]' for nil:NilClass`

## Usage

An `Option` is either the singleton `None` or an instance of `Some`:

    s = Some(1)
    s == Some(1) # true
    s != None    # true

Both `None` and instances of `Some` have the standard collection methods (including `filter`, for those of you who agree with me that `select` is a stupid name):

    s.each {|i| i + 1}   # 2
    s.map {|i| i + 1}    # Some(2)
    s.filter {|i| i > 1} # None

To get the raw values:

    s.get # 1
    s.each {|i| i} # 1
    None.get # RuntimeError: None has no value

Because of this, it's best to give a default:

    s.getOrElse(2)    # 1
    None.getOrElse(2) # 2

Blocks are supported for lazy loading the default:

    s.getOrElse {|| slow_calculation} # 1, slow_calculation is never done
    None.getOrElse {|| slow_calculation} # result of slow_calculation

The `Option()` method is a good way to get an Option. Any `value` is converted to `Some(value)`, while `nil` is converted to `None`:

    result      = Option(some_method_that_might_return_nil("something"))
    transformed = result.filter{|i| i > 2}.map{|i| i.to_s}
    puts filtered.getOrElse("default")

If `nil` is bad, so are exceptions. Eat them with `tryo`:

    result      = tryo {|| raise "silly error" }
    transformed = result.filter{|i| i > 2}.map{|i| i.to_s}
    puts filtered.getOrElse("default") # will be "default"

If you start using lots of Options you might want to flatten them with `flatMap`:

    s.map {|id| get_user_from_db(id) }      # Some(Some(User #1 ...))
    s.flatMap {|id| get_user_from_db(id) }  # Some(User #1 ...)

The block passed to `flatMap` must return an Option:

    id = Some("unknown id")
    id.flatMap {|id| get_user_from_db(id) } # None
    id.flatMap {|id| id}                    # RuntimeError: Did not return an Option