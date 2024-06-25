#!/usr/bin/bash

export EXTERNAL_TEST="true"
export WORKSPACE=/tmp

if [ -z "${KUBECONFIG}" ]; then
    echo "No kubeconfig file set for hub cluster"
    #fail
fi

if [ -z "${KUBECONFIG_EDGE}" ]; then
    echo "No kubeconfig file set for edge cluster"
    #fail
fi

pytest -lv --disable-warnings test_subscription_status_hub.py --kubeconfig $KUBECONFIG --junit-xml /tmp/test_subscription_status_hub.xml

pytest -lv --disable-warnings test_subscription_status_edge.py --kubeconfig $KUBECONFIG_EDGE --junit-xml /tmp/test_subscription_status_edge.xml

pytest -lv --disable-warnings test_validate_hub_site_components.py  --kubeconfig $KUBECONFIG --junit-xml /tmp/test_validate_hub_site_components.xml

KUBECONFIG=$KUBECONFIG_EDGE pytest -lv --disable-warnings test_validate_edge_site_components.py --kubeconfig $KUBECONFIG_EDGE --junit-xml /tmp/test_validate_edge_site_components.xml

pytest -lv --disable-warnings test_validate_pipelineruns.py --kubeconfig $KUBECONFIG --junit-xml /tmp/test_validate_pipelineruns.xml

pytest -lv --disable-warnings test_check_logging_hub.py --kubeconfig $KUBECONFIG --junit-xml /tmp/test_check_logging_hub.xml

KUBECONFIG=$KUBECONFIG_EDGE pytest -lv --disable-warnings test_check_logging_edge.py --kubeconfig $KUBECONFIG_EDGE --junit-xml /tmp/test_check_logging_edge.xml

KUBECONFIG=$KUBECONFIG_EDGE pytest -lv --disable-warnings test_toggle_machine_sensor.py --junit-xml /tmp/test_toggle_machine_sensor.xml

pytest -lv --disable-warnings test_pipeline_build_check.py --junit-xml /tmp/test_pipeline_build_check.xml