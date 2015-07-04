class AlertsController < ApplicationController
  def direct
    swal {
      success 'direct', 'direct rendering'
      function 'function(){ alert("raw alert") }'
    }
    case params[:direct_type]
      when 'json'
        render json: {json: :json}
      when 'text'
        render plain: 'text'
      when 'xml'
        render xml: '<xml><body>html</body></xml>'
      else
        # do nothing
    end
  end


  def show
    case params[:swal_type]
      when 'success'
        swal { success 'Success', 'success text' }
      when 'info'
        swal { info 'Info', 'info text' }
      when 'warning'
        swal { warning 'Warning', 'warning text' }
      when 'error'
        swal { error 'Error', 'error text' }
      when 'preset'
        swal { preset 'Preset', 'preset text' }
      else
        # do nothing
    end

    render :index
  end


  def templater
    swal { success 'template test', 'templating' }
  end
end

