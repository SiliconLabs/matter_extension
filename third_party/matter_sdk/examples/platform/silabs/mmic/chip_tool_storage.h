/*******************************************************************************
 * @file
 * @brief Chip-tool storage parser for matter ncp.
 *******************************************************************************
 * # License
 * <b>Copyright 2026 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon Laboratories Inc. Your use of this
 * software is governed by the terms of Silicon Labs Master Software License
 * Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement. This
 * software is distributed to you in Source Code format and is governed by the
 * sections of the MSLA applicable to Source Code.
 *
 ******************************************************************************/
#pragma once

#include <cstdint>
#include <string>
#include <vector>

// Fabric material extracted from a chip-tool storage pair
// (chip_tool_config.ini + chip_tool_config.alpha.ini) sitting in the current
// working directory. All cert blobs are Matter-TLV form. Key material is
// raw scalars / uncompressed EC points.
struct ChipToolStorage
{
    bool        loaded = false;
    std::string missingReason; // set when loaded == false; suitable for a warning

    uint64_t fabricId = 0;
    uint16_t vendorId = 0;

    // Root and intermediate certs (Matter-TLV form, straight from f/1/r / f/1/i).
    std::vector<uint8_t> rcacTlv;
    std::vector<uint8_t> icacTlv;

    // Identity Protection Key, 16 bytes, extracted from the f/1/k/0 TLV blob.
    std::vector<uint8_t> ipk;

    // Intermediate CA operational keypair (from ExampleOpCredsICAKey0).
    std::vector<uint8_t> icaPubKey;  // 65 bytes, uncompressed EC point
    std::vector<uint8_t> icaPrivKey; // 32 bytes, raw scalar
};

// Try to load chip-tool storage from ./chip_tool_config.ini and
// ./chip_tool_config.alpha.ini. On success sets `out.loaded = true` and fills
// all fields. On any failure (files missing, malformed, required keys absent)
// sets `out.loaded = false` and `out.missingReason` describes the problem.
// Never throws.
bool loadChipToolStorage(ChipToolStorage & out);
