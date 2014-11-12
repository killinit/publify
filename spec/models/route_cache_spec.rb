describe RouteCache, type: :model do

  it 'test_cache_clear' do
    RouteCache[:foo] = :bar
    RouteCache.clear
    assert_equal({}, RouteCache.instance_variable_get(:@cache))
  end

end
