using System;
using UnityEngine;

public class CameraController : MonoBehaviour {
    public float Sensitivity = 1.0f;

    private float _angle;

    private void Start() {
        _angle = transform.localRotation.eulerAngles.y;
    }

    private void Update() {
        if (Math.Abs(Input.GetAxis("Fire2")) > float.Epsilon) {
            Vector3 eulerAngles = transform.localRotation.eulerAngles;

            _angle += Input.GetAxis("Mouse X") * Sensitivity;

            _angle = ((_angle % 360.0f) + 360.0f) % 360.0f;

            transform.localRotation = Quaternion.Euler(eulerAngles.x, _angle, 0.0f);
        }
    }
}
