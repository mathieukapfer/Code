typedef char uint8_t;
typedef uint uint32_t;
typedef ulong uint64_t;

struct mppa_kann_context_private_s;
typedef struct mppa_kann_context_private_s mppa_kann_context_t;

struct mppa_kann_local_context_private_s;
typedef struct mppa_kann_local_context_private_s mppa_kann_local_context_t;

// MPPA function in C
// Local buffer order: local context, scratchpad, events

__attribute__((mppa_native))
ulong mppa_kann_get_sizeof_context();

__attribute__((mppa_native))
uint mppa_kann_init_context_from_params(__global mppa_kann_context_t *ctx,
                                        __global void *buffer,
                                        uint64_t buffer_size);

__attribute__((mppa_native))
uint mppa_kann_get_nbr_clusters(__global mppa_kann_context_t *ctx);

__attribute__((mppa_native))
uint mppa_kann_set_iobuffer_address_bynum(__global mppa_kann_context_t *ctx,
                                          uint32_t num,
                                          __global void *address);

__attribute__((mppa_native))
int mppa_kann_create_context(__global mppa_kann_context_t *ctx,
                             char *params_path);

__attribute__((mppa_native))
int mppa_kann_init(__local void *local_context, __local void *local_scratchpad,
                   __local void *evt_buf, __global mppa_kann_context_t *ctx,
                   int local_context_size, int local_scratchpad_size,
                   int evt_buf_size, unsigned clus_id);

__attribute__((mppa_native))
int mppa_kann_partial_init(__local void *local_ctx_buffer,
                           __local void *local_scratchpad,
                           __global mppa_kann_context_t *ctx_buffer,
                           int local_context_size, int local_scratchpad_size, unsigned clus_id);

__attribute__((mppa_native))
int mppa_kann_start(__local void *local_context,
                    __global mppa_kann_context_t *ctx,
                    __local void *barrier, unsigned clus_id);

__attribute__((mppa_native))
int mppa_kann_terminate(__local void *local_context,
                        __global mppa_kann_context_t *ctx, unsigned clus_id);

__attribute__((mppa_native))
int mppa_kann_partial_terminate(__local void *local_context,
                                __global mppa_kann_context_t *ctx, unsigned clus_id);

__attribute__((mppa_native))
int mppa_kann_process_frame(__local void *evt_buf,
                            mppa_kann_local_context_t *local_ctx,
                            __global mppa_kann_context_t *ctx,
                            unsigned clus_id);

// DDR<->SMEM functions

__attribute__((mppa_native))
void mppa_kann_save_local_ctx(const __global mppa_kann_context_t *ctx);
__attribute__((mppa_native))
void mppa_kann_restore_local_ctx(__global mppa_kann_context_t *ctx);
__attribute__((mppa_native))
mppa_kann_local_context_t *
mppa_kann_process_frame_prologue(__global mppa_kann_context_t *ctx, __local void *barrier,
                                 int iobuf_ids[16], __global void *iobuf_addrs[16], int nb_iobuds);
__attribute__((mppa_native))
void mppa_kann_process_frame_epilogue(__global mppa_kann_context_t *ctx);

// OpenCL-C kernels

__kernel void mppa_kann_get_sizeof_context_kernel(__global ulong *output)
{
    int gr_id = get_group_id(0);
    if (gr_id == 0) {
        *output = (ulong)mppa_kann_get_sizeof_context();
    }
}

__kernel void mppa_kann_init_context_from_params_kernel(
        __global mppa_kann_context_t *ctx,
        __global uint8_t *buffer,
        uint64_t buffer_size)
{
    int gr_id = get_group_id(0);
    if (gr_id == 0) {
        mppa_kann_init_context_from_params(ctx, buffer, buffer_size);
    }
}

__kernel void mppa_kann_get_nbr_clusters_kernel(__global void *ctx_buffer,
                                                __global uint *output)
{
    int gr_id = get_group_id(0);
    if (gr_id == 0) {
        *output = mppa_kann_get_nbr_clusters(
                    (__global mppa_kann_context_t *)ctx_buffer);
    }
}
__kernel void mppa_kann_set_iobuffer_address_bynum_kernel(
        __global void *ctx_buffer, uint32_t num, __global void *address)
{
    int gr_id = get_group_id(0);
    if (gr_id == 0) {
        mppa_kann_set_iobuffer_address_bynum(
                (__global mppa_kann_context_t *)ctx_buffer, num, address);
    }
}

__kernel void mppa_kann_init_kernel(__local void *local_ctx_buffer,
                                    __local void *local_scratchpad,
                                    __local void *evt_buf,
                                    __global void *ctx_buffer,
                                    int local_context_size,
                                    int local_scratchpad_size,
                                    int evt_buf_size,
                                    int nb_clus,
                                    int first_clus)
{
    int clus_id = get_group_id(0) - first_clus;
    if (clus_id >= 0 && clus_id < nb_clus) {
        mppa_kann_init(local_ctx_buffer, local_scratchpad, evt_buf,
                       (__global mppa_kann_context_t *)ctx_buffer,
                       local_context_size, local_scratchpad_size, evt_buf_size,
                       clus_id);
    } else {
        if (clus_id < 0) {
            clus_id += 5;
        }
        mppa_kann_partial_init(local_ctx_buffer, local_scratchpad,
                               (__global mppa_kann_context_t *)ctx_buffer,
                               local_context_size, local_scratchpad_size, clus_id);
    }
    mppa_kann_save_local_ctx(ctx_buffer);
}

__kernel void mppa_kann_start_kernel(__local void *local_ctx_buffer, __global void *ctx_buffer,
                                     __local void *barrier)
{
    mppa_kann_restore_local_ctx(ctx_buffer);
    mppa_kann_start(local_ctx_buffer, (__global mppa_kann_context_t *)ctx_buffer, barrier, get_group_id(0));
    mppa_kann_save_local_ctx(ctx_buffer);
}

void set_iobuffer_if_present(__global void *ctx_buffer, int id, __global void *addr)
{
    if (id >= 0) {
        mppa_kann_set_iobuffer_address_bynum(ctx_buffer, id, addr);
    }
}

void mppa_kann_process_frame_generic(__local void *local_ctx_buffer,
                                     __local void *local_scratchpad,
                                     __local void *evt_buf,
                                     __global void *ctx_buffer,
                                     __local void *kann_barrier,
                                     int *iobuf_ids, __global void **iobuf_addrs,
                                     int nb_iobufs)
{

    mppa_kann_local_context_t *local_ctx =
        mppa_kann_process_frame_prologue(ctx_buffer, kann_barrier, iobuf_ids, iobuf_addrs, nb_iobufs);

    mppa_kann_process_frame(evt_buf, local_ctx,
                            (__global mppa_kann_context_t *)ctx_buffer, get_group_id(0));
    mppa_kann_process_frame_epilogue(ctx_buffer);
}

__kernel void mppa_kann_process_frame_kernel(__local void *local_ctx_buffer,
                                             __local void *local_scratchpad,
                                             __local void *evt_buf,
                                             __global void *ctx_buffer,
                                             __local void *kann_barrier)
{
    mppa_kann_process_frame_generic(local_ctx_buffer, local_scratchpad, evt_buf,
                                    ctx_buffer, kann_barrier, 0x0, 0x0, 0);
}

__kernel void mppa_kann_process_frame_4_kernel(__local void *local_ctx_buffer,
                                               __local void *local_scratchpad,
                                               __local void *evt_buf,
                                               __global void *ctx_buffer,
                                               __local void *kann_barrier,
                                               int iobuf0_id, __global void *iobuf0_addr,
                                               int iobuf1_id, __global void *iobuf1_addr,
                                               int iobuf2_id, __global void *iobuf2_addr,
                                               int iobuf3_id, __global void *iobuf3_addr)
{
    int iobuf_ids[4] = {
        iobuf0_id, iobuf1_id, iobuf2_id, iobuf3_id
    };
    __global void *iobuf_addrs[4] = {
        iobuf0_addr, iobuf1_addr, iobuf2_addr, iobuf3_addr
    };
    mppa_kann_process_frame_generic(local_ctx_buffer, local_scratchpad, evt_buf,
                                    ctx_buffer, kann_barrier, iobuf_ids,
                                    iobuf_addrs, 4);
}

__kernel void mppa_kann_process_frame_16_kernel(__local void *local_ctx_buffer,
                                                __local void *local_scratchpad,
                                                __local void *evt_buf,
                                                __global void *ctx_buffer,
                                                __local void *kann_barrier,
                                                int iobuf0_id, __global void *iobuf0_addr,
                                                int iobuf1_id, __global void *iobuf1_addr,
                                                int iobuf2_id, __global void *iobuf2_addr,
                                                int iobuf3_id, __global void *iobuf3_addr,
                                                int iobuf4_id, __global void *iobuf4_addr,
                                                int iobuf5_id, __global void *iobuf5_addr,
                                                int iobuf6_id, __global void *iobuf6_addr,
                                                int iobuf7_id, __global void *iobuf7_addr,
                                                int iobuf8_id, __global void *iobuf8_addr,
                                                int iobuf9_id, __global void *iobuf9_addr,
                                                int iobuf10_id, __global void *iobuf10_addr,
                                                int iobuf11_id, __global void *iobuf11_addr,
                                                int iobuf12_id, __global void *iobuf12_addr,
                                                int iobuf13_id, __global void *iobuf13_addr,
                                                int iobuf14_id, __global void *iobuf14_addr,
                                                int iobuf15_id, __global void *iobuf15_addr)
{
    int iobuf_ids[16] = {iobuf0_id, iobuf1_id, iobuf2_id, iobuf3_id, iobuf4_id,
                         iobuf5_id, iobuf6_id, iobuf7_id, iobuf8_id, iobuf9_id,
                         iobuf10_id, iobuf11_id, iobuf12_id, iobuf13_id,
                         iobuf14_id, iobuf15_id};
    __global void *iobuf_addrs[16] = {
        iobuf0_addr, iobuf1_addr, iobuf2_addr, iobuf3_addr, iobuf4_addr,
        iobuf5_addr, iobuf6_addr, iobuf7_addr, iobuf8_addr, iobuf9_addr,
        iobuf10_addr, iobuf11_addr, iobuf12_addr, iobuf13_addr, iobuf14_addr,
        iobuf15_addr
    };
    mppa_kann_process_frame_generic(local_ctx_buffer, local_scratchpad, evt_buf,
                                    ctx_buffer, kann_barrier, iobuf_ids,
                                    iobuf_addrs, 16);
}

__kernel void mppa_kann_terminate_kernel(__local void *local_ctx_buffer,
                                         __global void *ctx_buffer,
                                         int nb_clus, int first_clus)
{
    mppa_kann_restore_local_ctx(ctx_buffer);
    int clus_id = get_group_id(0) - first_clus;
    if (clus_id >= 0 && clus_id < nb_clus) {
        mppa_kann_terminate(local_ctx_buffer,
                            (__global mppa_kann_context_t *)ctx_buffer, get_group_id(0));
    } else {
        if (clus_id < 0) {
            clus_id += 5;
        }
        mppa_kann_partial_terminate(local_ctx_buffer,
                                    (__global mppa_kann_context_t *)ctx_buffer, clus_id);
    }
}
