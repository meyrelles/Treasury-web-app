module ActionDispatch
  module Session
    class MongoidStore < AbstractStore
      def destroy_session(env, sid, options)
        self.send(:destroy, env)
        generate_sid unless options[:drop]
      end
    end
  end
end
