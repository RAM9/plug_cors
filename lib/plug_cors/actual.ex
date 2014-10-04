defmodule PlugCors.Actual do
  import Plug.Conn

  def handleRequest(conn, config) do
    conn |> check_method(config)
  end

  defp check_method(conn, config) do
    case Enum.find(config[:methods], fn(x) -> String.downcase(x) == String.downcase(conn.method) end) do
      nil ->
        conn      
        |> resp(403, "")
        |> halt
      _ ->
        origin = if config[:origins] == "*", do: "*", else: hd(get_req_header(conn, "Origin"))

        conn = conn |> put_resp_header("Access-Control-Allow-Origin", origin)

        if config[:supports_credentials] do
          conn = put_resp_header(conn, "Access-Control-Allow-Credentials", true)
        end

        if Enum.count(config[:expose_headers]) > 0 do
          conn = put_resp_header(conn, "Access-Control-Expose-Headers", Enum.join(config[:expose_headers], ","))
        end

        conn
    end
  end
end