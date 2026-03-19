//
// Copyright 2025 Mikhail Kasianov
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import SwiftUI

struct CrashTestView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("NSException") {
                    crashButton(
                        "NSGenericException",
                        subtitle: ".raise()",
                        systemImage: "exclamationmark.triangle"
                    ) {
                        NSException(
                            name: .genericException,
                            reason: "Test crash: NSGenericException",
                            userInfo: nil
                        ).raise()
                    }

                    crashButton(
                        "NSRangeException",
                        subtitle: "Array index out of bounds",
                        systemImage: "number.circle"
                    ) {
                        let array = [Int]()
                        _ = array[1]
                    }

                    crashButton(
                        "NSInvalidArgumentException",
                        subtitle: "Unrecognized selector",
                        systemImage: "questionmark.circle"
                    ) {
                        let object = NSObject()
                        object.perform(NSSelectorFromString("nonExistentMethod"))
                    }
                }

                Section("Fatal Error") {
                    crashButton(
                        "fatalError",
                        subtitle: "SIGTRAP",
                        systemImage: "bolt.fill"
                    ) {
                        fatalError("Test crash: fatalError")
                    }

                    crashButton(
                        "preconditionFailure",
                        subtitle: "SIGTRAP",
                        systemImage: "exclamationmark.octagon"
                    ) {
                        preconditionFailure("Test crash: preconditionFailure")
                    }
                }

                Section("Signal") {
                    crashButton(
                        "SIGABRT",
                        subtitle: "abort()",
                        systemImage: "xmark.circle"
                    ) {
                        abort()
                    }

                    crashButton(
                        "SIGFPE",
                        subtitle: "Division by zero",
                        systemImage: "divide.circle"
                    ) {
                        // Force integer division by zero via UnsafeMutablePointer
                        let zero = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
                        zero.pointee = 0
                        let one = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
                        one.pointee = 1
                        _ = one.pointee / zero.pointee
                        zero.deallocate()
                        one.deallocate()
                    }

                    crashButton(
                        "SIGSEGV",
                        subtitle: "Null pointer dereference",
                        systemImage: "memorychip"
                    ) {
                        let pointer = UnsafeMutablePointer<Int>(bitPattern: 0x1)!
                        pointer.pointee = 42
                    }

                    crashButton(
                        "SIGBUS",
                        subtitle: "Misaligned memory access",
                        systemImage: "bus"
                    ) {
                        let allocation = UnsafeMutableRawPointer.allocate(
                            byteCount: 16, alignment: 1
                        )
                        let misaligned = allocation.advanced(by: 1)
                            .assumingMemoryBound(to: Int64.self)
                        misaligned.pointee = 42
                        allocation.deallocate()
                    }

                    crashButton(
                        "SIGILL",
                        subtitle: "Illegal instruction",
                        systemImage: "cpu"
                    ) {
                        typealias IllegalFunc = @convention(c) () -> Void
                        var illegalInstruction: UInt32 = 0x00000000
                        let pointer = withUnsafeMutablePointer(to: &illegalInstruction) {
                            UnsafeMutableRawPointer($0)
                        }
                        let function = unsafeBitCast(pointer, to: IllegalFunc.self)
                        function()
                    }
                }
            }
            .navigationTitle("Crash Test")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func crashButton(
        _ title: String,
        subtitle: String,
        systemImage: String,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            // Dispatch after a short delay to let the UI update
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                action()
            }
        } label: {
            Label {
                VStack(alignment: .leading) {
                    Text(title)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } icon: {
                Image(systemName: systemImage)
                    .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    CrashTestView()
}
