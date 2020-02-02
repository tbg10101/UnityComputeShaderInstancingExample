using System.Runtime.InteropServices;
using UnityEngine;
using UnityEngine.Rendering;

public class ProceduralController : MonoBehaviour {
    public Camera Camera;
    public Mesh Mesh;
    public Material Material;

    private ComputeBuffer _inputPoints;
    private ComputeBuffer _argsBuffer;

    private static readonly int PositionBufferId = Shader.PropertyToID("positionBuffer");

    private void Start() {
        if (Camera == null) {
            Camera = Camera.main;
        }

        _inputPoints = new ComputeBuffer(8, Marshal.SizeOf<Vector4>());
        _inputPoints.SetData(new[] {
            new Vector4(1, 1, 1, 0),
            new Vector4(-1, 1, 1, 0),
            new Vector4(1, -1, 1, 0),
            new Vector4(-1, -1, 1, 0),

            new Vector4(1, 1, -1, 0),
            new Vector4(-1, 1, -1, 0),
            new Vector4(1, -1, -1, 0),
            new Vector4(-1, -1, -1, 0)
        });

        _argsBuffer = new ComputeBuffer(5, Marshal.SizeOf<uint>(), ComputeBufferType.IndirectArguments);
        _argsBuffer.SetData(new[] {
            Mesh.GetIndexCount(0), // index count per instance
            (uint)_inputPoints.count, // instance count
            Mesh.GetIndexStart(0), // start index location
            Mesh.GetBaseVertex(0), // base vertex location
            0u // start instance location
        });
    }

    private void Update() {
        Material.SetBuffer(PositionBufferId, _inputPoints);

        Graphics.DrawMeshInstancedIndirect(
            Mesh,
            0,
            Material,
            new Bounds(Vector3.zero, 10.0f * Vector3.one),
            _argsBuffer,
            0,
            null,
            ShadowCastingMode.Off,
            false,
            gameObject.layer,
            null,
            LightProbeUsage.Off,
            null);
    }

    private void OnDestroy() {
        _inputPoints.Dispose();
        _argsBuffer.Dispose();
    }
}
