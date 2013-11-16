package com.hackcess.angel;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothServerSocket;
import android.bluetooth.BluetoothSocket;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Looper;
import android.os.Vibrator;
import android.util.Log;
import android.widget.TextView;
import android.os.Handler;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.UUID;

/**
 * Created by olc on 16/11/13.
 */
public class BluetoothService {

    public final String TAG = "BluetoothService";

    public final UUID BT_UUID = UUID.fromString("f630f710-4e93-11e3-8f96-0800200c9a66"); // Autogenerated
    public BluetoothAdapter mBluetoothAdapter;
    public BluetoothServerSocket mBluetoothListenerSocket;

    public String alertMessage = "";

    void setStatusMessage(final String str) {
        mainActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mainActivity.setStatusText(str);
            }
        });
    }

    // The BroadcastReceiver that listens for discovered devices
    public final BroadcastReceiver mReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();

            // When discovery finds a device
            if (BluetoothDevice.ACTION_FOUND.equals(action)) {
                Log.d(TAG, "ACTION_FOUND");
                // Get the BluetoothDevice object from the Intent
                BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
                try {
                    onServerFoundClient(device.createInsecureRfcommSocketToServiceRecord(BT_UUID),
                            device.getName());
                } catch (IOException e) {
                    e.printStackTrace();
                }
                // When discovery is finished, change the Activity title
            } else if (BluetoothAdapter.ACTION_DISCOVERY_FINISHED.equals(action)) {
                Log.d(TAG, "ACTION_DISCOVERY_FINISHED");
                setStatusMessage("Finished");
            }
        }
    };


    MainActivity mainActivity;
    public BluetoothService(MainActivity mainActivity) {
        this.mainActivity = mainActivity;
        mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
    }


    // Starts listening for incoming connections
    public final void startListening() {
        try {
            mBluetoothListenerSocket = mBluetoothAdapter.listenUsingInsecureRfcommWithServiceRecord(
                    "BluetoothAlertReceiver", BT_UUID);
            // Launch thread waiting for connection
            Thread thread = new Thread()
            {
                @Override
                public void run() {
                    try {
                        Log.d(TAG, "Listening..");
                        while(true) {
                            onListenerFoundBroadcaster(mBluetoothListenerSocket.accept());
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            };

            thread.start();

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public final void startBroadcastingBluetooth() {
        if (mBluetoothAdapter.isEnabled()) {
            // Get discoverable devices to send them messages
            mBluetoothAdapter.startDiscovery();
        } else {
            Log.e(TAG, "startBroadcastingBluetooth: BT is not enabled");
        }
        mainActivity.setStatusText("Scanning..");
        Log.e(TAG, "startBroadcastingBluetooth");
    }

    private void onListenerFoundBroadcaster(BluetoothSocket client) {
        Log.d(TAG, "Listener: new broadcaster found");
        ConnectedThread mConnectedThread = new ConnectedThread(client, SocketType.READ_ONLY);
        mConnectedThread.start();
    }

    private void onServerFoundClient(BluetoothSocket client, String name) {
        Log.d(TAG, "onServerFoundClient: " + name);
        try {
            client.connect();
        } catch (IOException e) {
            Log.d(TAG, "Skipping this client - can't connect.");
        }
        ConnectedThread mConnectedThread = new ConnectedThread(client, SocketType.WRITE_ONLY);
        mConnectedThread.start();
    }

    private enum SocketType {
        READ_ONLY, WRITE_ONLY
    }
    private class ConnectedThread extends Thread {
        private final BluetoothSocket mmSocket;
        private final InputStream mmInStream;
        private final OutputStream mmOutStream;
        private final SocketType mmSocketType;

        public ConnectedThread(BluetoothSocket socket, SocketType socketType) {
            Log.d(TAG, "create ConnectedThread");
            mmSocket = socket;
            mmSocketType = socketType;
            InputStream tmpIn = null;
            OutputStream tmpOut = null;

            // Get the BluetoothSocket input and output streams
            try {
                tmpIn = socket.getInputStream();
                tmpOut = socket.getOutputStream();
            } catch (IOException e) {
                Log.e(TAG, "temp sockets not created", e);
            }

            mmInStream = tmpIn;
            mmOutStream = tmpOut;

            // Write a dummy var
            if (mmSocketType == SocketType.WRITE_ONLY) {
                setStatusMessage("Sending message..");
                write(alertMessage.getBytes());
                cancel();
            }
        }

        public void run() {
            Log.i(TAG, "BEGIN mConnectedThread");
            byte[] buffer = new byte[1024];
            int bytes;

            // Keep listening to the InputStream while connected
            while (true && mmSocketType == SocketType.READ_ONLY) {
                try {
                    // Read from the InputStream
                    bytes = mmInStream.read(buffer);
                    String str = new String(buffer, 0, bytes);
                    Log.e(TAG, "Message received: " + str);
                    mainActivity.runOnUiThread(new Runnable(){
                        public void run(){
                            mainActivity.onAlertReceived();
                        }
                    });
                } catch (IOException e) {
                    Log.d(TAG, "disconnected", e);
                    // Start the service over to restart listening mode
                    break;
                }
            }
        }

        /**
         * Write to the connected OutStream.
         * @param buffer  The bytes to write
         */
        public void write(byte[] buffer) {
            try {
                mmOutStream.write(buffer);
            } catch (IOException e) {
                Log.e(TAG, "Exception during write", e);
            }
        }

        public void cancel() {
            try {
                mmSocket.close();
            } catch (IOException e) {
                Log.e(TAG, "close() of connect socket failed", e);
            }
        }
    }

}
