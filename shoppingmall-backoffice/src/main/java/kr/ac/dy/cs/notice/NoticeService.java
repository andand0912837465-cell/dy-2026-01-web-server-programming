package kr.ac.dy.cs.notice;

import java.util.List;

public class NoticeService {
    private NoticeRepository noticeRepository = new NoticeRepository();

    public List<NoticeDto> getNotices() {
        return noticeRepository.selectAll();
    }

    public NoticeDto getNotice(Long id) {
        return noticeRepository.selectById(id);
    }

    public boolean registerNotice(NoticeDto dto) {
        return noticeRepository.insert(dto) > 0;
    }

    public boolean modifyNotice(NoticeDto dto) {
        return noticeRepository.update(dto) > 0;
    }

    public boolean removeNotice(Long id) {
        return noticeRepository.delete(id) > 0;
    }
}
