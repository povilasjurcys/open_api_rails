# frozen_string_literal: true

module GraphqlToRest
  module Test
    module RailsRoutesHelper
      def rails_route_double(http_method, path, controller_and_action, app: 'dummy_app1')
        path_double = double('RailsRoutePth', spec: path)
        controller, action = controller_and_action.split('#')

        full_controller = "graphql_to_rest/#{app}/api/v1/#{controller}"

        double(
          'RailsRoute',
          path: path_double,
          verb: http_method,
          defaults: { controller: full_controller, action: action }
        )
      end
    end
  end
end
