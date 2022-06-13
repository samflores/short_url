# frozen_string_literal: true

require_relative '../unit_helper'
require_relative '../../models/page'

describe Page do
  it 'validates the presence of target_url' do
    page = Page.new(target_url: nil)

    _(page.valid?).must_equal false
  end
end
