# Phx.Gen.Auth.Passwordless

## Installation

1. Add `phx_gen_auth_passwordless` to your list of dependencies in `mix.exs`

    ```elixir
    def deps do
      [
        {:phx_gen_auth_passwordless, github: "nwjlyons/phx_gen_auth_passwordless", only: :dev, runtime: false},
        {:bcrypt_elixir, "~> 2.0"},
      ]
    end
    ```
1. Install and compile the dependencies

    ```bash
    $ mix do deps.get, deps.compile
    ```

1. From the root of your phoenix app you can install the authentication system with the following command
 
    ```bash
    $ mix phx.gen.auth.passwordless Accounts User users
    ```

1. Update `router.ex`

    ```elixir
    scope "/users", ...Web do
     pipe_through :browser
       
     scope "/sign-in" do
       get "/", SignInCodeController, :create
       post "/", SignInCodeController, :create
       get "/check", SignInCodeController, :check
       post "/check", SignInCodeController, :check
     end
    end
    
    pipeline :protected do
      plug ...Web.Auth.Plugs.AuthenticationRequired
      plug ...Web.Auth.Plugs.FetchUserFromSession
    end
   
    scope "/", ...Web do
      pipe_through [:browser, :protected]
      
      # Protected routes  
    end
    ```
