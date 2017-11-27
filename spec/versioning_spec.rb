require "spec_helper"

RSpec.describe Versioning do
  it "has a version number" do
    expect(Versioning::VERSION).not_to be nil
  end
end
