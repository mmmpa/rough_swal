require 'rails_helper'

describe 'Alerts', type: :request do
  shared_examples_for 'write after link' do
    it 'get swal after link' do
      get first_path
      expect(response.body).not_to include('swal({')

      get '/alerts/index'
      expect(response.body).to include('swal({')
    end
  end

  before :each do
    get '/alerts/index'
  end

  it do
    get '/alerts/index'
    expect(response.body).not_to include('swal({')
  end

  context 'set preset' do
    it do
      expect { get '/alerts/swal/preset' }.to raise_exception(RoughSwal::Preset::NotFound)
    end

    it do
      RoughSwal.configure do
        preset(:preset) {
          confirm_button_color '#ccc'
        }
      end

      get '/alerts/swal/preset'
      expect(response.body).to include(':"#ccc"')
      expect(response.body).to include(':"Preset"')
      expect(response.body).to include(':"preset text"')

      get '/alerts/swal/warning'
      expect(response.body).not_to include(':"#ccc"')
    end
  end

  context 'set default' do
    it do
      RoughSwal.configure do
        default {
          confirm_button_color '#04c'
        }
      end

      get '/alerts/templater'
      expect(response.body).to include(':"#04c"')
    end

    it do
      RoughSwal.configure do
        default {
          confirm_button_color '#000'
        }
      end

      get '/alerts/templater'
      expect(response.body).to include(':"#000"')
    end
  end

  context 'with template' do
    it do
      get '/alerts/templater'
      expect(response.body).to include('swal({')
    end

    it 'not html, not write there' do
      get '/alerts/templater.json'
      expect(response.body).not_to include('swal({')

      get '/alerts/index'
      expect(response.body).to include('swal({')
    end
  end

  context 'with render method' do
    context 'render json' do
      let(:first_path) { '/alerts/direct/json' }
      include_examples 'write after link'
    end

    context 'render text' do
      let(:first_path) { '/alerts/direct/text' }
      include_examples 'write after link'
    end

    context 'render xml' do
      let(:first_path) { '/alerts/direct/xml' }
      include_examples 'write after link'
    end
  end

  context 'with short method' do
    it do
      get '/alerts/swal/error'
      expect(response.body).to include('"type":"error"')
    end

    it do
      get '/alerts/swal/info'
      expect(response.body).to include('"type":"info"')
    end

    it do
      get '/alerts/swal/success'
      expect(response.body).to include('"type":"success"')
    end

    it do
      get '/alerts/swal/warning'
      expect(response.body).to include('"type":"warning"')
    end
  end
end
