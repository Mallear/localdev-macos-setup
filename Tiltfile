settings = read_json('tilt_option.json', default={})

k8s_yaml('kubernetes.yaml')
k8s_resource('tilt-demo', port_forwards=8002)
docker_build('tilt-demo', '.',
  live_update = [
    sync('.', '/app'),
    run('pip install -r requirements.txt', trigger='requirements.txt')
  ])
