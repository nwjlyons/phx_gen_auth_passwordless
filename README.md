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

    ```
    $ mix do deps.get, deps.compile
    ```

### Running the generator

From the root of your phoenix app you can install the authentication system with the following command

```
$ mix phx.gen.auth.passwordless Accounts User users
```
