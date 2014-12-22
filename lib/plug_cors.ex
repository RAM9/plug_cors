defmodule PlugCors do
  import Plug.Conn
  @moduledoc """
    A CORS Plug

    Usage:

        plug PlugCors, origins: ["test.origin.test", "*.domain.com"], methods: ["GET", "POST"], headers: ["Authorization"]
    

    Parameters:

    * origins: A list of allowed origins or "\\*" for all origins. Default: "\\*". Can add use wildcards domains such as "*.domain.com" to match on the domain and all it's sub domains

    * methods: A list of allowed HTTP methods. Default: ["GET", "HEAD", "POST", "OPTIONS", "PUT", "PATCH", "DELETE"]

    * headers: A list of additionally allowed HTTP headers. Default: [] 
               These are in addition to 'PlugCors.Preflight.default_accept_headers'
    * expose_headers: A list of headers to expose to the browser via the "Access-Control-Expose-Headers" header. Default: [] (Will not output header)

    * max_age: The max cache age of the response in seconds "Access-Control-Max-Age" header. Default: 0 (Will not output header)

    * supports_credentials: Whether or not to allow cookies with requests "Access-Control-Allow-Credentials" header. Default: false (Will not output header)

  """
  
  def init(opts) do 
    [
      origins: Keyword.get(opts, :origins, "*"),
      methods: Keyword.get(opts, :methods, ["GET", "HEAD", "POST", "OPTIONS", "PUT", "PATCH", "DELETE"]),
      headers: Keyword.get(opts, :headers, []),
      expose_headers: Keyword.get(opts, :expose_headers, []),
      max_age: Keyword.get(opts, :max_age, 0),
      supports_credentials: Keyword.get(opts, :supports_credentials, false)
    ]
  end

  def call(conn, config) do
    get_req_header(conn, "origin") 
    |> handle_request(conn, config)
  end

  defp handle_request([], conn, _config) do
    conn
  end

  defp handle_request(_, conn, config) do
    case is_preflight_request?(conn) do
      true ->
        PlugCors.Preflight.call(conn, config)
      _ ->
        PlugCors.Actual.call(conn, config)
    end
  end

  defp is_preflight_request?(conn) do
    get_req_header(conn, "access-control-request-method") != [] and conn.method == "OPTIONS"
  end
end
