from yt_odin.logserver import FULLY_AVAILABLE_STATE
from yt_odin.test_helpers import make_check_dir, configure_and_run_checks

CHECK_OPTIONS = {
    "temp_tables_path": "//tmp",
    "soft_map_timeout": 70,
}


def test_map_result(yt_env):
    proxy_url = yt_env.yt_client.config["proxy"]["url"]
    checks_path = make_check_dir("map_result", CHECK_OPTIONS)
    storage = configure_and_run_checks(proxy_url, checks_path)
    assert abs(storage.get_service_states("map_result")[-1] - FULLY_AVAILABLE_STATE) <= 0.001
