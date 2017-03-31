# encoding: utf-8
require 'spec_helper'

RSpec.describe 'example-java-jar-hello' do
  let (:app) { 'example-java-jar-hello' }

  it 'should have hello world in job logs' do
    stdout, stderr, status = apc "job logs #{app} --no-tail"
    expect(stdout).to include("Hello, World")
  end
end