Rails.application.routes.draw do

  scope :alerts do
    get 'index', format: false, to: 'alerts#index'
    get 'templater', to: 'alerts#templater'
    get 'direct/:direct_type', format: false, to: 'alerts#direct', as: :direct
    get 'swal/:swal_type', format: false, to: 'alerts#show', constraions: %w(success info warning error), as: :swal
  end
end
