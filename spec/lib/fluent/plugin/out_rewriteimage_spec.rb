require 'spec_helper'

describe do
  let(:driver) {Fluent::Test::OutputTestDriver.new(Fluent::RewriteImageOutput, 'test.metrics').configure(config)}
  let(:image_file) {File.join(File.dirname(__FILE__), 'imagefile.jpg')}

  let(:instance) {driver.instance}
  let(:record) {{'image_field' => image_file}}
  let(:time) {0}
  let(:filter) {
    d = driver
    r = record.dup
    d.instance.filter_record('test', Time.now, r)
    
    r
  }

  describe 'emit' do

    context 'base64encoded_false' do
      let(:config) {
        %[
           add_tag_prefix hoge
           image_source_key image_field
           image_key rewrited_image_field
           base64encode false
        ]
      }

      it do
        filter['rewrited_image_field'].should eq File.open(image_file, 'rb').read
      end
    end

    context 'base64encoded_true' do
      let(:config) {
        %[
           add_tag_prefix hoge
           image_source_key image_field
           image_key rewrited_image_field
           base64encode true
        ]
      }

      it do
        Base64.decode64(filter['rewrited_image_field']).should eq File.open(image_file, 'rb').read
      end
    end
    
  end

end