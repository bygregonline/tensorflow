// RUN: flatbuffer_translate -mlir-to-tflite-flatbuffer %s -o - | flatbuffer_to_string - | FileCheck --dump-input-on-failure %s

func @main(tensor<40x37xf32>, tensor<40x37xf32>) -> tensor<40x40xf32> {
^bb0(%arg0: tensor<40x37xf32>, %arg1: tensor<40x37xf32>):
  // CHECK:      {
  // CHECK-NEXT:  version: 3,
  // CHECK-NEXT:  operator_codes: [ {
  // CHECK-NEXT:    builtin_code: FULLY_CONNECTED,
  // CHECK-NEXT:    version: 2
  // CHECK-NEXT:  } ],
  // CHECK-NEXT:  subgraphs: [ {
  // CHECK-NEXT:    tensors: [ {
  // CHECK-NEXT:      shape: [ 40, 37 ],
  // CHECK-NEXT:      buffer: 1,
  // CHECK-NEXT:      name: "Input",
  // CHECK-NEXT:      quantization: {
  // CHECK-EMPTY:
  // CHECK-NEXT:      }
  // CHECK-NEXT:    }, {
  // CHECK-NEXT:      shape: [ 40, 37 ],
  // CHECK-NEXT:      buffer: 2,
  // CHECK-NEXT:      name: "Input1",
  // CHECK-NEXT:      quantization: {
  // CHECK-EMPTY:
  // CHECK-NEXT:      }
  // CHECK-NEXT:    }, {
  // CHECK-NEXT:      shape: [ 40, 40 ],
  // CHECK-NEXT:      buffer: 3,
  // CHECK-NEXT:      name: "tfl.fully_connected",
  // CHECK-NEXT:      quantization: {
  // CHECK-EMPTY:
  // CHECK-NEXT:      }
  // CHECK-NEXT:    }, {
  // CHECK-NEXT:      shape: [ 40, 40 ],
  // CHECK-NEXT:      buffer: 4,
  // CHECK-NEXT:      name: "tfl.fully_connected:1",
  // CHECK-NEXT:      quantization: {
  // CHECK-EMPTY:
  // CHECK-NEXT:      }
  // CHECK-NEXT:    } ],
  // CHECK-NEXT:    inputs: [ 0, 1 ],
  // CHECK-NEXT:    outputs: [ 2 ],
  // CHECK-NEXT:    operators: [ {
  // CHECK-NEXT:      inputs: [ 0, 1, -1 ],
  // CHECK-NEXT:      outputs: [ 2, 3 ],
  // CHECK-NEXT:      builtin_options_type: FullyConnectedOptions,
  // CHECK-NEXT:      builtin_options: {
  // CHECK-NEXT:        weights_format: SHUFFLED4x16INT8
  // CHECK-NEXT:      }
  // CHECK-NEXT:    } ],
  // CHECK-NEXT:    name: "main"
  // CHECK-NEXT:  } ],
  // CHECK-NEXT:  description: "MLIR Converted.",
  // CHECK-NEXT:  buffers: [ {
  // CHECK-EMPTY:
  // CHECK-NEXT:  }, {
  // CHECK-EMPTY:
  // CHECK-NEXT:  }, {
  // CHECK-EMPTY:
  // CHECK-NEXT:  }, {
  // CHECK-EMPTY:
  // CHECK-NEXT:  }, {
  // CHECK-EMPTY:
  // CHECK-NEXT:  } ]
  // CHECK-NEXT:}

  %cst = constant unit
  %0 = "tfl.pseudo_input"(%arg0) : (tensor<40x37xf32>) -> tensor<40x37xf32> loc("Input")
  %1 = "tfl.pseudo_input"(%arg1) : (tensor<40x37xf32>) -> tensor<40x37xf32> loc("Input")
  %2:2 = "tfl.fully_connected"(%0, %1, %cst) {fused_activation_function = "NONE", keep_num_dims = false, weights_format = "SHUFFLED4x16INT8"} : (tensor<40x37xf32>, tensor<40x37xf32>, none) -> (tensor<40x40xf32>, tensor<40x40xf32>)
  return %2 : tensor<40x40xf32>
}
